//
//  DomainMapper.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

protocol DomainMapper {
  associatedtype EntityType
  func toDomain() -> EntityType
}
