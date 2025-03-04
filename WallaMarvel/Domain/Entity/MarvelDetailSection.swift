//
//  MarvelDetailSection.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 4/3/25.
//

import Foundation

enum MarvelDetailSection: Int, CaseIterable {
  case comics, events, stories, series
  
  var title: String {
    switch self {
    case .comics: return "Comics"
    case .events: return "Events"
    case .stories: return "Stories"
    case .series: return "Series"
    }
  }
}
