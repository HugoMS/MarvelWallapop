//
//  HeroDetails.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation

struct HeroDetails {
  let comics: [HeroData]
  let series: [HeroData]
  let events: [HeroData]
  let stories: [HeroData]
}

extension HeroDetails {
  func availableSections() -> [MarvelDetailSection] {
    var sections: [MarvelDetailSection] = []
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
    return sections
    
  }
}
