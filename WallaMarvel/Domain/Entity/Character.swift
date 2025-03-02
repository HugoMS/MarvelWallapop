//
//  Character.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

struct Character: Identifiable {
  
  let id: Int?
  let name: String?
  let description: String?
  let modified: String?
  let thumbnailURL: URL?
  var isFavorite: Bool?
  
  var safeDescription: String {
    if let description, !description.isEmpty {
      return description
    } else {
      return "No Description"
    }
  }
  
  init(id: Int?,
       name: String?,
       description: String? = nil,
       modified: String? = nil,
       thumbnailURL: URL? = nil,
       isFavorite: Bool? = false) {
    self.id = id
    self.name = name
    self.description = description
    self.modified = modified
    self.thumbnailURL = thumbnailURL
  }
}

// MARK: - Equatable

extension Character: Equatable {
  static func == (lhs: Character, rhs: Character) -> Bool {
    lhs.id == rhs.id
  }
}
