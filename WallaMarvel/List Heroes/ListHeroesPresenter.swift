import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
  var ui: ListHeroesUI? { get set }
  func screenTitle() -> String
  func getHeroes(from offset: Int) async
}

protocol ListHeroesUI: AnyObject {
  func update(heroes: [Character])
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
  var ui: ListHeroesUI?
  private let getHeroesUseCase: GetHeroesUseCaseProtocol
  private var searchText = ""
  
  init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
    self.getHeroesUseCase = getHeroesUseCase
  }
  
  func screenTitle() -> String {
    "List of Heroes"
  }
  
  // MARK: UseCases
  
  func getHeroes(from offset: Int) async {
    let result = await getHeroesUseCase.execute(from: offset, by: searchText)
      switch result {
      case .success(let response):
        ui?.update(heroes: response.results ?? [])
      case .failure(let error):
        print(error)
      }
    }
  }
  
