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
  
  func viewDidLoad() {
    heroDetails = HeroDetails()
    Task { await fetchComics() }
    Task { await fetchSeries() }
    Task { await fetchEvents() }
    Task { await fetchStories() }
  }
  
  private func fetchComics() async {
    do {
      let comicsResult = try await getHeroDataUseCase.execute(by: character.id, from: 0, type: .comic).get()
      heroDetails?.comics = comicsResult.results ?? []
      await ui?.updateView()
    } catch {
      print("Error fetching comics: \(error)")
    }
  }
  
  private func fetchSeries() async {
    do {
      let seriesResult = try await getHeroDataUseCase.execute(by: character.id, from: 0, type: .series).get()
      heroDetails?.series = seriesResult.results ?? []
      await ui?.updateView()
    } catch {
      print("Error fetching series: \(error)")
    }
  }
  
  private func fetchEvents() async {
    do {
      let eventsResult = try await getHeroDataUseCase.execute(by: character.id, from: 0, type: .events).get()
      heroDetails?.events = eventsResult.results ?? []
      await ui?.updateView()
    } catch {
      print("Error fetching events: \(error)")
    }
  }
  
  private func fetchStories() async {
    do {
      let storiesResult = try await getHeroDataUseCase.execute(by: character.id, from: 0, type: .stories).get()
      heroDetails?.stories = storiesResult.results ?? []
      await ui?.updateView()
    } catch {
      print("Error fetching stories: \(error)")
    }
  }
  
  func getCharacter() -> Character {
    character
  }
}
