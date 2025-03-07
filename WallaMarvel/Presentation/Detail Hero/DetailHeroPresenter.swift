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
  func getHeroDetails() -> HeroDetails
}

protocol DetailHeroUI: AnyObject {
  func updateView()
}

final class DetailHeroPresenter {
  private let getHeroDataUseCase: GetHeroDataUseCaseProtocol
  private let character: Character
  private weak var ui: DetailHeroUI?
  private var heroDetails: HeroDetails
  
  init(character: Character, getHereoDataUseCase: GetHeroDataUseCaseProtocol = GetHeroData()) {
    self.character = character
    self.getHeroDataUseCase = getHereoDataUseCase
    self.heroDetails = HeroDetails(hero: character)
  }
  
  func inject(ui: DetailHeroUI) {
    self.ui = ui
  }
}

// MARK: - DetailHeroePresenterProtocol

extension DetailHeroPresenter: DetailHeroPresenterProtocol {
  func getHeroDetails() -> HeroDetails {
    heroDetails
  }
  
  func screenTitle() -> String {
    "Hero Detail"
  }
  
  func viewDidLoad() {
    heroDetails = HeroDetails(hero: character, loader: true)
    ui?.updateView()
    for type in HeroDataType.allCases {
      Task { await fetchHeroData(of: type) }
    }
  }
  
  private func fetchHeroData(of type: HeroDataType) async {
    do {
      let heroDataResult = try await getHeroDataUseCase.execute(by: character.id, from: 0, type: type).results
      heroDetails.loader = false
      switch type {
      case .comic:
        heroDetails.comics = heroDataResult ?? []
      case .series:
        heroDetails.series = heroDataResult ?? []
      case .events:
        heroDetails.events = heroDataResult ?? []
      case .stories:
        heroDetails.stories = heroDataResult ?? []
      }
      
        ui?.updateView()
      
    } catch {
      print("Error fetching \(type) data: \(error)")
    }
  }
  
  func getCharacter() -> Character {
    character
  }
}
