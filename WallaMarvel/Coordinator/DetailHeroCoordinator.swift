//
//  DetailHeroCoordinator.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 7/3/25.
//

import Foundation
import UIKit

class DetailHeroCoordinator: Coordinator {
  weak var parentCoordinator: AppCoordinator?
  var childCoordinators: [Coordinator] = []
  
  private let navigationController: UINavigationController
  private let character: Character
  
  init(navigationController: UINavigationController, character: Character) {
    self.navigationController = navigationController
    self.character = character
  }
  
  func start() {
    let presenter = DetailHeroPresenter(character: character)
    let detailHeroViewController = DetailHeroViewController(presenter: presenter, coordinator: self)
    presenter.inject(ui: detailHeroViewController)
    navigationController.pushViewController(detailHeroViewController, animated: true)
  }
  
  func didFinish() { 
    parentCoordinator?.removeChild(self)
  }
}
