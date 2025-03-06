import UIKit

final class ListHeroesViewController: BaseViewController {
  var mainView: ListHeroesView { return view as! ListHeroesView  }
  private var activityIndicator: UIActivityIndicatorView?
  var presenter: ListHeroesPresenterProtocol?
  var listHeroesProvider: ListHeroesAdapter?
  var isLoading = false
  private let searchController = UISearchController(searchResultsController: nil)
  
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
  func showEmpty(delegate: (any EmptyContentViewProtocol)?) {
    DispatchQueue.main.async { [weak self] in
      self?.showEmptyContentView(delegate: delegate)
    }
  }
  
  func update(heroes: [Character]) {
    hideEmptyContentView()
    listHeroesProvider?.heroes += heroes
    isLoading = false
    
    finishPagination()
    DispatchQueue.main.async {
      self.toggleActivityIndicator(visible: false)
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
}
