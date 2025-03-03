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
    mainView.refreshInformation()
    setupCollectionView()
  }
}

// MARK: - Private Methods

extension DetailHeroViewController: DetailHeroUI {
  func updateView() {
    mainView.collectionView.reloadData()
    //mainView.collectionView.layoutIfNeeded()
    mainView.layoutCollectionViewAndUpdateScrollViewContent()
  }
}

// MARK: - Private Methods

extension DetailHeroViewController {
  private func setupCollectionView() {
    mainView.collectionView.dataSource = self
    mainView.collectionView.delegate = self
    
    mainView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    mainView.collectionView.register(SectionHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "header")
  }
}

  
  // MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension DetailHeroViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.getHeroDataView().count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.getHeroDataView()[section].items?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .systemBlue
    
    let label = UILabel()
    label.text = presenter.getHeroDataView()[indexPath.section].items?[indexPath.row].title ?? "EMPTY"
    label.textColor = .white
    label.textAlignment = .center
    label.frame = cell.bounds
    cell.contentView.addSubview(label)
    
    return cell
  }
  
  
  // MARK: - Header para las Secciones
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
    
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                 withReuseIdentifier: "header",
                                                                 for: indexPath) as! SectionHeaderView
    header.titleLabel.text = presenter.getHeroDataView()[indexPath.section].title
    return header
  }
}


extension DetailHeroViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: collectionView.bounds.width, height: 50)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: collectionView.bounds.width, height: 50)
  }
}

class SectionHeaderView: UICollectionReusableView {
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

  
