//
//  LoaderCollectionReusableView.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 7/3/25.
//

import Foundation
import UIKit

final class LoaderCollectionReusableView: UICollectionReusableView {
  static let reuseIdentifier = "LoaderCollectionReusableView"
  
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .gray
    activityIndicator.startAnimating()
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
    footerView.addSubview(activityIndicator)
    activityIndicator.center = footerView.center
    addSubview(footerView)
    NSLayoutConstraint.activate([
      footerView.centerXAnchor.constraint(equalTo: centerXAnchor),
      footerView.centerYAnchor.constraint(equalTo: centerYAnchor),
      
    ])
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
