//
//  MarvelRepositoryMock.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import Foundation
@testable import WallaMarvel

class MarvelRepositoryMock : MarvelRepositoryProtocol {
  var shouldThrowError = false
  var getHeroesCount = 0
  var getHeroesResult: PaginatedResponse<Character> = PaginatedResponse(offset: 0, limit: 1, total: 1, count: 1, results: [ .init(id: 1, name: "Spiderman", description: "Spiderman description")])
  var getHeroData = 0
  var getHeroDataResult: PaginatedResponse<HeroData> = PaginatedResponse(offset: 0, limit: 0, total: 0, count: 0, results: [.init(id: 1, title: "Spiderman", thumbnailURL: URL(string: "https://www.url.com")!)])
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponse<Character> {
    getHeroesCount += 1
    if shouldThrowError {
      throw URLError(.badServerResponse)
    }
    return getHeroesResult
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: WallaMarvel.HeroDataType) async throws -> PaginatedResponse<HeroData> {
    getHeroData += 1
    if shouldThrowError {
      throw URLError(.badServerResponse)
    }
    return getHeroDataResult
  }
}
