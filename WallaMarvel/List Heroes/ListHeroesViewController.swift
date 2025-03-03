import UIKit

final class ListHeroesViewController: UIViewController {
  var mainView: ListHeroesView { return view as! ListHeroesView  }
  
  var presenter: ListHeroesPresenterProtocol?
  var listHeroesProvider: ListHeroesAdapter?
  var isLoading = false
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  
  override func loadView() {
    view = ListHeroesView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
  func update(heroes: [Character]) {
    listHeroesProvider?.heroes += heroes
    isLoading = false
    finishPagination()
  }
  
  func finishPagination() {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      self.mainView.heroesTableView.tableFooterView = nil
    }
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      104
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

