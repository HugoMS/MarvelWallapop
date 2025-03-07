import UIKit

final class ListHeroesViewController: BaseViewController {
  var mainView: ListHeroesView { return view as! ListHeroesView  }
  private var activityIndicator: UIActivityIndicatorView?
  var presenter: ListHeroesPresenterProtocol?
  var listHeroesProvider: ListHeroesAdapter?
  var isLoading = false
  let searchController = UISearchController(searchResultsController: nil)
  private var hasStartedSearching = false
  override func loadView() {
    view = ListHeroesView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    toggleActivityIndicator(visible: true)
    listHeroesProvider = ListHeroesAdapter(tableView: mainView.heroesTableView)
    presenter?.ui = self
    Task {
      isLoading = true
      await presenter?.getHeroes(from: 0)
    }
    title = presenter?.screenTitle()
    mainView.heroesTableView.delegate = self
    configureSearchController()
  }
  
  func loadData() {
    guard !isLoading else { return }
    isLoading = true
    if listHeroesProvider?.heroes.count != 0 {
      let activityIndicator = UIActivityIndicatorView(style: .medium)
      activityIndicator.color = .gray
      activityIndicator.startAnimating()
      let footerView = UIView(frame: CGRect(x: 0, y: 0, width: mainView.heroesTableView.bounds.width, height: 50))
      footerView.addSubview(activityIndicator)
      activityIndicator.center = footerView.center
      mainView.heroesTableView.tableFooterView = footerView
      activityIndicator.startAnimating()
    }
    Task {
      await presenter?.loadMoreCharactersIfNeeded()
    }
  }
}

extension ListHeroesViewController: ListHeroesUI {
  func showEmpty(delegate: (any EmptyContentViewProtocol)?, showReloadButton: Bool) {
    DispatchQueue.main.async { [weak self] in
      self?.showEmptyContentView(delegate: delegate, showReloadButton: showReloadButton)
    }
  }
  
  func update(heroes: [Character], pagination: Bool) {
    if pagination {
      listHeroesProvider?.heroes += heroes
    } else {
      listHeroesProvider?.heroes = heroes
    }
    
    isLoading = false
    DispatchQueue.main.async {
      heroes.isEmpty ?  self.showEmpty(delegate: nil, showReloadButton: false)  : self.hideEmptyContentView()
      if !pagination {
        self.mainView.heroesTableView.scrollsToTop = true
      }
      self.toggleActivityIndicator(visible: false)
      self.mainView.heroesTableView.tableFooterView = nil
    }
  }
  
  func finishPagination() {
    DispatchQueue.main.async {
      self.mainView.heroesTableView.tableFooterView = nil
    }
  }
  
  func resetView() {
    hideEmptyContentView()
    toggleActivityIndicator(visible: true)
  }
}

extension ListHeroesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let character = listHeroesProvider?.heroes[indexPath.row] else { return }
    let presenter = DetailHeroPresenter(character: character)
    let detailHereoViewController = DetailHeroViewController(presenter: presenter)
    presenter.inject(ui: detailHereoViewController)
    
    navigationController?.pushViewController(detailHereoViewController, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentHeight = scrollView.contentSize.height
    let offsetY = scrollView.contentOffset.y
    let height = scrollView.frame.size.height
    
    if contentHeight - offsetY <= height * 1.5 {
      loadData()
    }
  }
}

// MARK: - Private Methods

private extension ListHeroesViewController {
  func toggleActivityIndicator(visible: Bool) {
    if visible {
      let activityIndicator = UIActivityIndicatorView(style: .large)
      activityIndicator.color = .gray
      activityIndicator.startAnimating()
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(activityIndicator)
      NSLayoutConstraint.activate([
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ])
      
      self.activityIndicator = activityIndicator
    }
    else {
      activityIndicator?.removeFromSuperview()
      activityIndicator = nil
    }
  }
  
  func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Find..."
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
    
    definesPresentationContext = true
  }
}


// MARK: - UISearchResultsUpdating
extension ListHeroesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchText = searchController.searchBar.text ?? ""
    
    if !hasStartedSearching {
      hasStartedSearching = true
      return
    }
    
    if searchText.isEmpty {
      hasStartedSearching = false
    }
    presenter?.search(for: searchText)    
  }
}
