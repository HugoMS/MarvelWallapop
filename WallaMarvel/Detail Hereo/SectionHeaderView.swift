//
//  SectionHeaderView.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation
import UIKit

class SectionHeaderView: UICollectionReusableView {
  static let reuseIdentifier = "HeaderView"
  
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
}
