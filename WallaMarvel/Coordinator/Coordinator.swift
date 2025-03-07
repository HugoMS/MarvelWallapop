//
//  Coordinator.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 7/3/25.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  func start()
  func didFinish()
}

extension Coordinator {
  func removeChild(_ coordinator: Coordinator) {
    childCoordinators.removeAll { $0 === coordinator }
  }
}

