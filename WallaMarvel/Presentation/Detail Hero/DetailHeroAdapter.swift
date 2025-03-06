//
//  DetailHeroAdapter.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 6/3/25.
//

import Foundation
import UIKit

final class DetailHeroAdapter: NSObject {
  var heroDetails: HeroDetails
  private let collectionView: UICollectionView
  private var dataSource: UICollectionViewDiffableDataSource<MarvelDetailSection, HeroData>!
  
  init(collectionView: UICollectionView, heroDetails: HeroDetails) {
    self.collectionView = collectionView
    self.heroDetails = heroDetails
    super.init()
    configureDataSource()
  }
  
  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<MarvelDetailSection, HeroData>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarvelItemCell.reuseIdentifier, for: indexPath) as! MarvelItemCell
      cell.configure(with: item)
      return cell
    }
    
    dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
      let section = self.heroDetails.availableSections()[indexPath.section]
      
      if section == .hero  {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeroHeaderView.reuseIdentifier, for: indexPath) as! HeroHeaderView
        let character =  self.heroDetails.hero
        header.configure(with: character.name, description: character.description, image: character.thumbnailURL)
        return header
      } else {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
        header.setTitle(section.title)
        return header
      }
    }
  }
  
  func update(with heroDetails: HeroDetails) {
    self.heroDetails = heroDetails
    var snapshot = NSDiffableDataSourceSnapshot<MarvelDetailSection, HeroData>()
    let availableSections = heroDetails.availableSections()
    snapshot.appendSections(availableSections)
    if availableSections.contains(.comics) {
      snapshot.appendItems( heroDetails.comics, toSection: .comics)
    }
    
    if availableSections.contains(.stories) {
      snapshot.appendItems( heroDetails.stories, toSection: .stories)
    }
    if availableSections.contains(.series) {
      snapshot.appendItems( heroDetails.series, toSection: .series)
    }
    
    if availableSections.contains(.events) {
      snapshot.appendItems( heroDetails.events, toSection: .events)
    }
    
    DispatchQueue.main.async { [weak self] in
      self?.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
}
