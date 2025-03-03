//
//  GetHeroData.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation

enum HeroDataType {
  case comic, series, events, stories
  
  var path: String {
    switch self {
    case .comic:
      return "/comics"
    case .series:
      return "/series"
    case .events:
      return "/events"
    case .stories:
      return "/stories"
    }
  }
}

protocol  GetHeroDataUseCaseProtocol {
  
  /// Get a list of comics from the Marvel API.
  func execute(by characterId: Int, from offset: Int, type: HeroDataType) async -> Result<PaginatedResponse<HeroData>, AppError>
}

// MARK: - Implementation -

class GetHeroData: GetHeroDataUseCaseProtocol {
  
  private let repository: MarvelRepositoryProtocol
  
  init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
    self.repository = repository
  }
  
  func execute(by characterId: Int, from offset: Int, type: HeroDataType) async -> Result<PaginatedResponse<HeroData>, AppError> {
    return await repository.getData(by: characterId, from: offset, type: type)
  }
  
}
