import Foundation

protocol MarvelRepositoryProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponse<Character>
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType) async throws -> PaginatedResponse<HeroData>
}

final class MarvelRepository: MarvelRepositoryProtocol {
  private let dataSource: MarvelDataSourceProtocol
  
  init(dataSource: MarvelDataSourceProtocol = MarvelDataSource()) {
    self.dataSource = dataSource
  }
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponse<Character> {
    do {
      let data = try await dataSource.getHeroes(from: offset, by: searchKey)
      let characters = data.toDomain(dataType: Character.self)
      return characters
    } catch let error as NetworkError {
      throw map(error)
    }
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType)  async throws -> PaginatedResponse<HeroData> {
    do {
      let data = try await dataSource.getHeroData(by: characterId, from: offset, type: type)
      let heroData = data.toDomain(dataType: HeroData.self)
      return heroData
    } catch let error as NetworkError {
      throw map(error)
    }
  }
  
  func map(_ error: NetworkError) -> AppError {
    switch error {
    case .networkError(let error):
      return  AppError.networkError(error.localizedDescription)
    case .invalidServerResponse:
      return AppError.serverError("Invalid Server Response")
    case .decodingError(let error):
      return AppError.parsingError( error.localizedDescription)
    case .badURL:
      return AppError.serverError("Bad URL")
    }
  }
}
