//
//  ListHeroesUIMock.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import Foundation
@testable import WallaMarvel

class ListHeroesUIMock : ListHeroesUI {
  var updateCount = 0
  var finishPaginationCount = 0
  var showEmptyCount = 0
  var resetViewCount = 0
  var showLoaderCount = 0
  
  func update(heroes: [Character], pagination: Bool) {
    updateCount += 1
  }
  
  func finishPagination() {
    finishPaginationCount += 1
  }
  
  func showEmpty(delegate: EmptyContentViewProtocol?, showReloadButton: Bool) {
    showEmptyCount += 1
  }
  
  func resetView() {
    resetViewCount += 1
  }
  
  func showLoader(visible: Bool) {
    showLoaderCount += 1
  }
}
