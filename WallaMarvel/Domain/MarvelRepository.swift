import Foundation

protocol MarvelRepositoryProtocol {
  func getHeroes(from offset: Int, by searchKey: String?) async -> Result<PaginatedResponse<Character>, AppError>
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
}
