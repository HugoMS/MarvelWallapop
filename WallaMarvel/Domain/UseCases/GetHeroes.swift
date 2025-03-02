import Foundation

protocol GetHeroesUseCaseProtocol {
  func execute(from offset: Int, by searchKey: String?) async -> Result<PaginatedResponse<Character>, AppError>
}

struct GetHeroes: GetHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }
    
  func execute(from offset: Int, by searchKey: String?) async -> Result<PaginatedResponse<Character>, AppError> {
    return await repository.getHeroes(from: offset, by: searchKey)
    }
}
