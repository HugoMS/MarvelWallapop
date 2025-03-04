//
//  DetailHeroViewController.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation
import UIKit

final class DetailHeroViewController: UIViewController {
  
  let presenter: DetailHeroPresenterProtocol
  var mainView: DetailHeroView { return view as! DetailHeroView  }
  
  init(presenter: DetailHeroPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = DetailHeroView(delegate: presenter)
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Task {
      await presenter.viewDidLoad()
    }
    title = presenter.screenTitle()
  }
}

// MARK: - Private Methods

extension DetailHeroViewController: DetailHeroUI {
  func updateView() {
    guard let heroDetails = presenter.getHeroDetails() else { return }
    mainView.update(with: heroDetails)
  }
}
