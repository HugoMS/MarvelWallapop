import Foundation

protocol MarvelRepositoryProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async -> Result<PaginatedResponse<Character>, AppError>
  func getData(by characterId: Int, from offset: Int, type: HeroDataType) async -> Result<PaginatedResponse<HeroData>, AppError>
}

final class MarvelRepository: MarvelRepositoryProtocol {
  private let dataSource: MarvelDataSourceProtocol
  
  init(dataSource: MarvelDataSourceProtocol = MarvelDataSource()) {
    self.dataSource = dataSource
  }
  
  func getHeroes(from offset: Int, by searchKey: String?) async -> Result<PaginatedResponse<Character>, AppError> {
    do {
      let data = try await dataSource.getHeroes(from: offset, by: searchKey)
      let characters = data.toDomain(dataType: Character.self)
      return .success(characters)
    } catch {
      print(error.self)
      return .failure(.networkError("Error fetching data"))
    }
  }
  
  func getData(by characterId: Int, from offset: Int, type: HeroDataType) async -> Result<PaginatedResponse<HeroData>, AppError> {
    do {
      let data = try await dataSource.getData(by: characterId, from: offset, type: type)
      let heroData = data.toDomain(dataType: HeroData.self)
      return .success(heroData)
    } catch {
      print(error.self)
      return .failure(.networkError("Error fetching data"))
    }
  }
}
