//
//  PaginatedResponseModel.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

struct PaginatedResponseModel<T>: Codable  where T: Codable, T: DomainMapper {
  let offset, limit, total, count: Int?
  let results: [T]?
}

