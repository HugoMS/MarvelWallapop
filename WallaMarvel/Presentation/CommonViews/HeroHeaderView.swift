//
//  HeroHeaderView.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation
import UIKit

final class HeroHeaderView: UICollectionReusableView {
  static let reuseIdentifier = "HeroHeaderView"
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 16
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 24)
    label.textColor = .label
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .label
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(imageView)
    addSubview(nameLabel)
    addSubview(descriptionLabel)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 150),
      imageView.heightAnchor.constraint(equalToConstant: 250),
      
      nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
      nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
      descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
      
    ])
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func configure(with name: String, description: String?, image: URL?) {
    nameLabel.text = name
    descriptionLabel.text = description
    imageView.kf.setImage(with: image)
  }
}
