//
//  PaginatedResponse.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

// MARK: - PaginatedResponse

struct PaginatedResponse<T: Equatable>: Equatable {
  let offset, limit, total, count: Int?
  let results: [T]?
  
  static func == (lhs: PaginatedResponse<T>, rhs: PaginatedResponse<T>) -> Bool {
    lhs.offset == rhs.offset &&
    lhs.limit == rhs.limit &&
    lhs.total == rhs.total &&
    lhs.count == rhs.count &&
    lhs.results == rhs.results
  }
}

