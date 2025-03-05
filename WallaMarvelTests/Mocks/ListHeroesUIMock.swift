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
  func update(heroes: [Character]) {
    updateCount += 1
  }
  
  func finishPagination() {
    finishPaginationCount += 1
  }
}
