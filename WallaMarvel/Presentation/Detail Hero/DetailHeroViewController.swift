//
//  DetailHeroViewController.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation
import UIKit

final class DetailHeroViewController: BaseViewController {
  
  let presenter: DetailHeroPresenterProtocol
  var detailHeroProvider: DetailHeroAdapter?
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
    detailHeroProvider = DetailHeroAdapter(collectionView: mainView.collectionView, heroDetails: presenter.getHeroDetails())
    Task {
      await presenter.viewDidLoad()
    }
    title = presenter.screenTitle()
  }
}

// MARK: - DetailHeroUI

extension DetailHeroViewController: DetailHeroUI {
  
  func updateView() {
    let heroDetails = presenter.getHeroDetails()
    DispatchQueue.main.async {[weak self] in
      self?.detailHeroProvider?.update(with: heroDetails)
    }
  }
}
