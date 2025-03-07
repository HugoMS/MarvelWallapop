//
//  MarvelDataSourceMock.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import Foundation
@testable import WallaMarvel

class MarvelDataSourceMock: MarvelDataSourceProtocol {
  var shouldThrowError = false
  var getHeroesCount = 0
  var getHeroesResult: PaginatedResponseModel<CharacterDataModel> = PaginatedResponseModel(offset: 0, limit: 0, total: 0, count: 0, results: [])
  var getHeroDataCount = 0
  
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponseModel<CharacterDataModel> {
    getHeroesCount += 1
    if shouldThrowError {
      throw URLError(.badServerResponse)
    }
    return getHeroesResult
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType) async throws -> PaginatedResponseModel<HeroDataModel> {
    getHeroDataCount += 1
    if shouldThrowError {
      throw URLError(.badServerResponse)
    }
    return PaginatedResponseModel(offset: 0, limit: 0, total: 0, count: 0, results: [])
  }
}
