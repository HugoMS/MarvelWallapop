//
//  MarvelDetailSection.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation

enum MarvelDetailSection: Int, CaseIterable {
  case hero, comics, events, stories, series, loader
  
  var title: String {
    switch self {
    case .hero: return "Hero"
    case .comics: return "Comics"
    case .events: return "Events"
    case .stories: return "Stories"
    case .series: return "Series"
    case .loader: return ""
    }
  }
}
