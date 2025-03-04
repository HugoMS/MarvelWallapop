//
//  MarvelItemCell.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation
import UIKit

class MarvelItemCell: UICollectionViewCell {
  static let reuseIdentifier = "MarvelItemCell"
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func setupViews() {
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
    titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 2
    
    let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 8
    contentView.addSubview(stack)
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: contentView.topAnchor),
      stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 120),
      imageView.widthAnchor.constraint(equalToConstant: 100)
    ])
  }
  
  func configure(with item: HeroData) {
    titleLabel.text = item.title
    imageView.kf.setImage(with: item.thumbnailURL)
  }
}
