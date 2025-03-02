//
//  AppError.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

enum AppError: Error, Equatable {
  case networkError(String)
  case parsingError(String)
  case serverError(String)
}
