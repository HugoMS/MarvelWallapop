//
//  GetHeroDataUseCaseMock.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import Foundation
@testable import WallaMarvel


class GetHeroDataUseCaseMock: GetHeroDataUseCaseProtocol {
  var executeCount = 0
  var shouldThrowError = false
  var executedTypes: [HeroDataType] = []
  var executeResult: PaginatedResponse<HeroData> = .init(offset: 0, limit: 1, total: 1, count: 1, results: [.init(id: 1, title: "Iron Man Comic")])
  func execute(by characterId: Int, from offset: Int, type: HeroDataType) async throws -> PaginatedResponse<HeroData> {
    executedTypes.append(type)
    executeCount += 1
    if shouldThrowError {
      throw AppError.networkError("Network Error")
    }
    return executeResult
  }
}

class DetailHeroUIMock: DetailHeroUI {
  var updateCount = 0
  func updateView() {
    updateCount += 1
  }
}

