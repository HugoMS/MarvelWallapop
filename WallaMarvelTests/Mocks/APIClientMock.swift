//
//  APIClientMock.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 7/3/25.
//

import Foundation
@testable import WallaMarvel

class APIClientMock: APIClientProtocol {
  var getHeroesCount = 0
  var getHeroDataCount = 0
  func getHeroes(from offset: Int, by searchKey: String?) async throws -> BaseResponseModel<PaginatedResponseModel<CharacterDataModel>> {
    getHeroesCount += 1
    let character = CharacterDataModel(id: 1, name: "Spiderman", characterDescription: nil, thumbnail: .init(path: nil, thumbnailExtension: nil))
    
    return BaseResponseModel(code: 200, status: "OK", data: .init(offset: 0, limit: 0, total: 0, count: 0, results: [character]))
  }
  
  func getHeroData(by characterId: Int, from offset: Int, type: HeroDataType) async throws -> BaseResponseModel<PaginatedResponseModel<HeroDataModel>> {
    getHeroDataCount += 1
    return BaseResponseModel(code: 200, status: "OK", data: .init(offset: 0, limit: 0, total: 0, count: 0, results: [.init(id: 1, title: "Spiderman", thumbnail: nil)]))
  }
}
