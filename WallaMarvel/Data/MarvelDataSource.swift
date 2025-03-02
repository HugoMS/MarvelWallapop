import Foundation

typealias HeroesResponse = BaseResponseModel<PaginatedResponseModel<CharacterDataModel>>

protocol MarvelDataSourceProtocol {
    func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponseModel<CharacterDataModel>
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
}
