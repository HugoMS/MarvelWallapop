//
//  HeroData.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation

struct HeroData: Identifiable {
  
  let id: Int
  let title: String
  let thumbnailURL: URL?
  
  // MARK: - Init -
  
  init(id: Int,
       title: String,
       thumbnailURL: URL? = nil) {
    self.id = id
    self.title = title
    self.thumbnailURL = thumbnailURL
  }
}

// MARK: - Equatable

extension HeroData: Equatable {
  
  static func == (lhs: HeroData, rhs: HeroData) -> Bool {
    lhs.id == rhs.id
  }
  
}
