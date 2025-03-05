//
//  GetHeroesUseCaseMock.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import Foundation
@testable import WallaMarvel

class GetHeroesUseCaseMock: GetHeroesUseCaseProtocol {
  var shouldThrowError = false
  var executeCount = 0
  var executeResult: PaginatedResponse<Character> = .init(offset: 0, limit: 1, total: 1, count: 1, results: [.init(id: 1, name: "Hulk", description: "Strongest Avenger", thumbnailURL: nil)])
  func execute(from offset: Int, by searchKey: String?) async throws -> PaginatedResponse<Character> {
    executeCount += 1
    if shouldThrowError {
      throw AppError.networkError("Network Error")
    }
    return executeResult
  }

}
