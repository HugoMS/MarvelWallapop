//
//  PaginatedResponseModel+DomainMapper.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

extension PaginatedResponseModel {
  typealias EntityType = PaginatedResponse
  func toDomain<U>(dataType: U.Type) -> PaginatedResponse<U> {
    return PaginatedResponse<U>(offset: offset,
                                limit: limit,
                                total: total,
                                count: count,
                                results: (results ?? []).compactMap({$0.toDomain() as? U }
                                                                   )
    )
  }
}
