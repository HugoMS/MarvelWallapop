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
  
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  let heroImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 24)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .darkGray
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
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
  
  func refreshInformation() {
    guard let character = delegate?.getCharacter() else { return }
    heroImageView.kf.setImage(with: character.thumbnailURL)
    nameLabel.text = character.name
    descriptionLabel.text = character.description
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
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
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
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
      let section = MarvelDetailSection.allCases[indexPath.section]
      header.setTitle(section.title)
      return header
    }
  }
}
