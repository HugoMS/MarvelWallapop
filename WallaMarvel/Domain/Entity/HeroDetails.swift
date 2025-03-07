//
//  HeroDetails.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation

struct HeroDetails {
  var hero: Character
  var comics: [HeroData]
  var series: [HeroData]
  var events: [HeroData]
  var stories: [HeroData]
  var loader: Bool
  
  init(
    hero: Character,
    comics: [HeroData] = [],
    series: [HeroData] = [],
    events: [HeroData] = [],
    stories: [HeroData] = [],
    loader: Bool = false
  ) {
    self.hero = hero
    self.comics = comics
    self.series = series
    self.events = events
    self.stories = stories
    self.loader = loader
  }
}

extension HeroDetails {
  func availableSections() -> [MarvelDetailSection] {
    var sections: [MarvelDetailSection] = [.hero ]
    if !comics.isEmpty {
      sections.append(.comics)
    }
    if !series.isEmpty {
      sections.append(.series)
    }
    if !events.isEmpty {
      sections.append(.events)
    }
    if !stories.isEmpty {
      sections.append(.stories)
    }
    if loader {
      sections.append(.loader)
    }
    return sections
    
  }
}
