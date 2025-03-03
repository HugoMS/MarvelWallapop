//
//  DetailHeroView.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation
import UIKit

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
  
  let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  
  init(delegate: DetailHeroPresenterProtocol) {
    self.delegate = delegate
    
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layoutCollectionViewAndUpdateScrollViewContent()
    
  }
  
  private func setupView() {
    backgroundColor = .white
    
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(stackView)
    stackView.addArrangedSubview(heroImageView)
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(descriptionLabel)
    contentView.addSubview(collectionView)
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = nil
    collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = false
    collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }
  
  // MARK: - Constraints
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      
      heroImageView.widthAnchor.constraint(equalToConstant: 200),
      heroImageView.heightAnchor.constraint(equalToConstant: 250),
      
      collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      collectionView.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  func refreshInformation() {
    guard let character = delegate?.getCharacter() else { return }
    heroImageView.kf.setImage(with: character.thumbnailURL)
    nameLabel.text = character.name
    descriptionLabel.text = character.description
  }
  
  func layoutCollectionViewAndUpdateScrollViewContent() {
    // layout collection view
    collectionView.collectionViewLayout.invalidateLayout()
    collectionView.layoutIfNeeded()
    collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    layoutIfNeeded()
    
    let totalHeight = collectionView.frame.maxY
    scrollView.contentSize.height = totalHeight
    contentView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
  }
}
