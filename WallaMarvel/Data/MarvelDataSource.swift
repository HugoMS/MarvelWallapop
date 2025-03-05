import Foundation

typealias HeroesResponse = BaseResponseModel<PaginatedResponseModel<CharacterDataModel>>
typealias DataResponse = BaseResponseModel<PaginatedResponseModel<HeroDataModel>>

protocol MarvelDataSourceProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponseModel<CharacterDataModel>
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType) async throws -> PaginatedResponseModel<HeroDataModel>
}

final class MarvelDataSource: MarvelDataSourceProtocol {
  private let apiClient: APIClientProtocol
  
  init(apiClient: APIClientProtocol = APIClient()) {
    self.apiClient = apiClient
  }
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponseModel<CharacterDataModel> {
    let result: HeroesResponse = try await apiClient.getHeroes(from: offset, by: searchKey)
    return result.data
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType) async throws -> PaginatedResponseModel<HeroDataModel> {
    let response: DataResponse = try await apiClient.getHeroData(by: characterId, from: offset, type: type)
    return response.data
  }
}
