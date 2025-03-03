//
//  DetailHeroPresenter.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation

protocol DetailHeroePresenterProtocol: AnyObject {
  func screenTitle() -> String
  func viewDidLoad() async
  func getCharacter() -> Character
}


final class DetailHeroPresenter {
  private let getHeroDataUseCase: GetHeroDataUseCaseProtocol
  private let character: Character
  
  init(character: Character, getHereoDataUseCase: GetHeroDataUseCaseProtocol = GetHeroData()) {
    self.character = character
    self.getHeroDataUseCase = getHereoDataUseCase
  }
  
 
}

// MARK: - DetailHeroePresenterProtocol

extension DetailHeroPresenter: DetailHeroePresenterProtocol {
  func screenTitle() -> String {
    character.name ?? ""
  }
  
  func viewDidLoad() async {
    async let comics = getHeroDataUseCase.execute(by: character.id ?? 0, from: 0, type: .comic)
    async let series = getHeroDataUseCase.execute(by: character.id ?? 0, from: 0, type: .series)
    async let events = getHeroDataUseCase.execute(by: character.id ?? 0, from: 0, type: .events)
    async let stories = getHeroDataUseCase.execute(by: character.id ?? 0, from: 0, type: .stories)
    
    let (storiesResult, seriesResult, eventsResult, comicsResult) = await (stories, series, events, comics)
    print("storiesResult: \(storiesResult) \n")
    print("seriesResult: \(seriesResult) \n")
    print("seriesResult: \(seriesResult) \n")
    print("comicsResult: \(comicsResult) \n")
 
  }
  
  func getCharacter() -> Character {
    character
  }
}
