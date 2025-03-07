//
//  DetailHeroView.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation
import UIKit
import Kingfisher

final class DetailHeroView: UIView {
  
  // MARK: - UI Components
  
  private weak var delegate: DetailHeroPresenterProtocol?
  
  var collectionView: UICollectionView!
  
  init(delegate: DetailHeroPresenterProtocol) {
    self.delegate = delegate
    
    super.init(frame: .zero)
    configureCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    backgroundColor = .white
    addSubview(collectionView)
  }
  
  private func configureCollectionView() {
    let layout = createLayout()
    collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    collectionView.register(MarvelItemCell.self, forCellWithReuseIdentifier: MarvelItemCell.reuseIdentifier)
    collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)    
    collectionView.register(HeroHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeroHeaderView.reuseIdentifier)
    collectionView.register(LoaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LoaderCollectionReusableView.reuseIdentifier)
    addSubview(collectionView)
  }
  
  // MARK: - Constraints
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
    ])
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      // item
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
      // group
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
      
      // section
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
      
      // Header
      var headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
      if sectionIndex == 0 {
        headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400))
      }
    
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]
      
      return section
    }
  }
}
