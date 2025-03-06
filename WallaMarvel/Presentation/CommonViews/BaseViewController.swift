//
//  BaseViewController.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 6/3/25.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
  private var emptyContentView: EmptyContentView? {
    willSet {
      emptyContentView?.removeFromSuperview()
    }
  }
  
  func showEmptyContentView(delegate: EmptyContentViewProtocol? = nil) {
    let value = EmptyContentView(delegate: delegate)
    emptyContentView = value
    value.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(value)
    NSLayoutConstraint.activate([
      value.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      value.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      value.topAnchor.constraint(equalTo: view.topAnchor),
      value.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    view.bringSubviewToFront(value)
  
  }
  
  func hideEmptyContentView() {
    emptyContentView = nil
  }
  
}

