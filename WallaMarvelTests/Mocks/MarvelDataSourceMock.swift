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
  var getHeroesResult: PaginatedResponseModel<WallaMarvel.CharacterDataModel> = PaginatedResponseModel(offset: 0, limit: 0, total: 0, count: 0, results: [])
  var getHeroData = 0
  
  
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> PaginatedResponseModel<WallaMarvel.CharacterDataModel> {
    getHeroesCount += 1
    if shouldThrowError {
      throw URLError(.badServerResponse)
    }
    return getHeroesResult
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: WallaMarvel.HeroDataType) async throws -> PaginatedResponseModel<WallaMarvel.HeroDataModel> {
    getHeroData += 1
    if shouldThrowError {
      throw URLError(.badServerResponse)
    }
    return PaginatedResponseModel(offset: 0, limit: 0, total: 0, count: 0, results: [])
  }
}
