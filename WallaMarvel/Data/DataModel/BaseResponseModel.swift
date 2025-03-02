//
//  BaseResponseModel.swift
//  WallaMarvel
//
//  Created by Hugo Morelli on 2/3/25.
//

import Foundation

struct BaseResponseModel<T: Codable>: Codable {
  let code: Int
  let status: String
  let data: T
}
