import Foundation

protocol GetHeroesUseCaseProtocol {
  func execute(from offset: Int, by searchKey: String?) async throws -> PaginatedResponse<Character>
}

struct GetHeroes: GetHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }
    
  func execute(from offset: Int, by searchKey: String?) async throws -> PaginatedResponse<Character> {
    return try await repository.getHeroes(from: offset, by: searchKey)
    }
}
