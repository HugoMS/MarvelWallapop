import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
  var ui: ListHeroesUI? { get set }
  func screenTitle() -> String
  func getHeroes(from offset: Int) async
  func loadMoreCharactersIfNeeded() async
}

protocol ListHeroesUI: AnyObject {
  func update(heroes: [Character])
  func finishPagination()
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
  
  var ui: ListHeroesUI?
  private let getHeroesUseCase: GetHeroesUseCaseProtocol
  private var searchText = ""
  private var limit = APIConstants.defaultLimit
  private var totalCount = 0
  private var currentOffset = 0
  
  
  init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
    self.getHeroesUseCase = getHeroesUseCase
  }
  
  func screenTitle() -> String {
    "List of Heroes"
  }
  
  // MARK: UseCases
  
  func getHeroes(from offset: Int) async {
    do {
      let data = try await getHeroesUseCase.execute(from: offset, by: searchText)
      totalCount = data.total ?? 0
      ui?.update(heroes: data.results ?? [])
    } catch {
      print(error)
    }
  }
  
  
  func loadMoreCharactersIfNeeded() async {
    guard currentOffset < totalCount else {
      ui?.finishPagination()
      return }
    currentOffset += limit
    await getHeroes(from: currentOffset)
  }
}

