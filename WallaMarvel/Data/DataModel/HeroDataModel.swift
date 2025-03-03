//
//  HeroDataModel.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 3/3/25.
//

import Foundation

struct HeroDataModel: Codable {
  let id: Int
  let title: String
  let thumbnail: Thumbnail?
}


extension HeroDataModel: DomainMapper {
  
  func toDomain() -> HeroData {
    return HeroData(
      id: id,
      title: title,
      thumbnailURL: thumbnail?.url
    )
  }
}
