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
  
  private var collectionView: UICollectionView!

  private var dataSource: UICollectionViewDiffableDataSource<MarvelDetailSection, HeroData>!
  
  init(delegate: DetailHeroPresenterProtocol) {
    self.delegate = delegate
    
    super.init(frame: .zero)
    configureCollectionView()
    configureDataSource()
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
      // Item size
      let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
      // Group size (horizontal scrolling)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      // Section
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
      section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
      
      // Header
      var headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
      if sectionIndex == 0 {
        headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400))
      }
    
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]
      
      return section
    }
  }
  
  func update(with heroDetails: HeroDetails) {
    var snapshot = NSDiffableDataSourceSnapshot<MarvelDetailSection, HeroData>()
    let availableSections = heroDetails.availableSections()
    snapshot.appendSections(availableSections)
    if availableSections.contains(.comics) {
      snapshot.appendItems( heroDetails.comics, toSection: .comics)
    }
    
    if availableSections.contains(.events) {
      snapshot.appendItems( heroDetails.events, toSection: .events)
    }
    if availableSections.contains(.stories) {
      snapshot.appendItems( heroDetails.stories, toSection: .stories)
    }
    if availableSections.contains(.series) {
      snapshot.appendItems( heroDetails.series, toSection: .series)
    }
    
    DispatchQueue.main.async { [weak self] in
      self?.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<MarvelDetailSection, HeroData>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelItemCell.reuseIdentifier, for: indexPath) as! MarvelItemCell
      cell.configure(with: item)
      return cell
    }
    
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      let section = MarvelDetailSection.allCases[indexPath.section]
      
     
      if section == .hero  {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeroHeaderView.reuseIdentifier, for: indexPath) as! HeroHeaderView
        guard let character = self.delegate?.getCharacter() else { return header }
        header.configure(with: character.name, description: character.description, image: character.thumbnailURL)
        return header
      } else {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
        header.setTitle(section.title)
        return header
      }
    }
  }
}
