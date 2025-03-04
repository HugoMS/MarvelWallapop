//
//  Character.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

struct Character: Identifiable {
  let id: Int
  let name: String
  let description: String?
  let thumbnailURL: URL?
  
  var safeDescription: String {
    if let description, !description.isEmpty {
      return description
    } else {
      return "No Description"
    }
  }
  
  init(id: Int,
       name: String,
       description: String? = nil,
       thumbnailURL: URL? = nil) {
    self.id = id
    self.name = name
    self.description = description
    self.thumbnailURL = thumbnailURL
  }
}

// MARK: - Equatable

extension Character: Equatable {
  static func == (lhs: Character, rhs: Character) -> Bool {
    lhs.id == rhs.id
  }
}
