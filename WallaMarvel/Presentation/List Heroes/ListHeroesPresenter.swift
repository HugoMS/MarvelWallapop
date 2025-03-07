import Foundation
import Combine

protocol ListHeroesPresenterProtocol: AnyObject {
  var ui: ListHeroesUI? { get set }
  func screenTitle() -> String
  func getHeroes(from offset: Int) async
  func loadMoreCharactersIfNeeded() async
  func search(for text: String)
}

protocol ListHeroesUI: AnyObject {
  func update(heroes: [Character], pagination: Bool)
  func finishPagination()
  func showEmpty(delegate: EmptyContentViewProtocol?, showReloadButton: Bool)
  func resetView()
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
  var ui: ListHeroesUI?
  private let getHeroesUseCase: GetHeroesUseCaseProtocol
  private var searchText = ""
  private var limit = APIConstants.defaultLimit
  private var totalCount = 0
  private var currentOffset = 0
  private var searchQuery = PassthroughSubject<String, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  
  
  init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
    self.getHeroesUseCase = getHeroesUseCase
    setupSearchObserver()
  }
  
  func screenTitle() -> String {
    "List of Heroes"
  }
  
  // MARK: UseCases
  
  func getHeroes(from offset: Int) async {
    do {
      let data = try await getHeroesUseCase.execute(from: offset, by: searchText.isEmpty ? nil : searchText)
      totalCount = data.total ?? 0
      currentOffset += limit
      ui?.update(heroes: data.results ?? [], pagination: data.offset != 0)
    } catch {
      ui?.showEmpty(delegate: self, showReloadButton: true)
    }
  }
  
  func loadMoreCharactersIfNeeded() async {
    guard currentOffset < totalCount else {
      ui?.finishPagination()
      return }
   
    await getHeroes(from: currentOffset)
  }
  
  func search(for text: String){
    searchQuery.send(text)
  }
}


// MARK: - EmptyContentViewProtocol

extension ListHeroesPresenter: EmptyContentViewProtocol {
  func didTapReload() {
    ui?.resetView()
    Task {
      await getHeroes(from: 0)
    }
  }
  
}

// MARK: - Private Methods

private extension ListHeroesPresenter {
  private func setupSearchObserver() {
    searchQuery
      .debounce(for: .milliseconds(700), scheduler: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] query in
        self?.performSearch(query: query)
      }
      .store(in: &cancellables)
  }
  
  private func performSearch(query: String) {
    
    currentOffset = 0
    searchText = query
    Task{
      await getHeroes(from: 0)
    }
  }
}
  
