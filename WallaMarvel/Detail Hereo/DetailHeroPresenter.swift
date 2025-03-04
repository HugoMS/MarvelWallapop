//
//  DetailHeroPresenter.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation

protocol DetailHeroPresenterProtocol: AnyObject {
  func screenTitle() -> String
  func viewDidLoad() async
  func getCharacter() -> Character
  func getHeroDetails() -> HeroDetails?
}

@MainActor
protocol DetailHeroUI: AnyObject {
  func updateView()
}

final class DetailHeroPresenter {
  private let getHeroDataUseCase: GetHeroDataUseCaseProtocol
  private let character: Character
  private weak var ui: DetailHeroUI?
  public var heroDetails: HeroDetails?
  
  init(character: Character, getHereoDataUseCase: GetHeroDataUseCaseProtocol = GetHeroData()) {
    self.character = character
    self.getHeroDataUseCase = getHereoDataUseCase
  }
  
  func inject(ui: DetailHeroUI) {
    self.ui = ui
  }
}

// MARK: - DetailHeroePresenterProtocol

extension DetailHeroPresenter: DetailHeroPresenterProtocol {
  func getHeroDetails() -> HeroDetails? {
    heroDetails
  }
  
  func screenTitle() -> String {
    character.name
  }
  
  func viewDidLoad() async {
    async let comics = getHeroDataUseCase.execute(by: character.id, from: 0, type: .comic)
    async let series = getHeroDataUseCase.execute(by: character.id, from: 0, type: .series)
    async let events = getHeroDataUseCase.execute(by: character.id, from: 0, type: .events)
    async let stories = getHeroDataUseCase.execute(by: character.id, from: 0, type: .stories)
    do {
      let (storiesResult, seriesResult, eventsResult, comicsResult) = try await (stories.get(), series.get(), events.get(), comics.get())
      heroDetails = HeroDetails(
        comics: comicsResult.results ?? [],
        series: seriesResult.results ?? [],
        events: eventsResult.results ?? [],
        stories: storiesResult.results ?? []
      )
      await ui?.updateView()
    } catch {
      print("Error: \(error)")
    }
  }
  
  func getCharacter() -> Character {
    character
  }
}
