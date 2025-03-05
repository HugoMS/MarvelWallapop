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
    } catch {
      throw error
    }
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType)  async throws -> PaginatedResponse<HeroData> {
    do {
      let data = try await dataSource.getHeroData(by: characterId, from: offset, type: type)
      let heroData = data.toDomain(dataType: HeroData.self)
      return heroData
    } catch {
      throw error
    }
  }
}
