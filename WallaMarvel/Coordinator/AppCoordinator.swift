//
//  AppCoordinator.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 7/3/25.
//

import Foundation
import UIKit

protocol AppCoordinatorProtocol: AnyObject {
  func goToDetail(character: Character)
}
  
final class AppCoordinator: Coordinator {
  
  var childCoordinators: [Coordinator] = []
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let presenter = ListHeroesPresenter()
    let listHeroesViewController = ListHeroesViewController(presenter: presenter, coordinator: self)
    presenter.ui = listHeroesViewController
    navigationController.pushViewController(listHeroesViewController, animated: false)
  }
  
  func didFinish() {
    removeChild(self)
  }

}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {
  func goToDetail(character: Character) {
    let coordinator = DetailHeroCoordinator(
      navigationController: navigationController,
      character: character
    )
    coordinator.parentCoordinator = self
    coordinator.start()
    childCoordinators.append(coordinator)
  }
}
