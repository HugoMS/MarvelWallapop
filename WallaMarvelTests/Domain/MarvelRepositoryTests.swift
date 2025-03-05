//
//  MarvelRepositoryTests.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import XCTest
@testable import WallaMarvel

final class MarvelRepositoryTests: XCTestCase {
  
  // MARK: - Properties -
  
  var sut: MarvelRepository!
  var dataSourceMock: MarvelDataSourceProtocolMock!
  
  // MARK: - Fake Data -

    override func setUpWithError() throws {
      dataSourceMock = MarvelDataSourceProtocolMock()
      sut = MarvelRepository(dataSource: dataSourceMock)
    }

    override func tearDownWithError() throws {
      sut = nil
      dataSourceMock = nil
      try super.tearDownWithError()
    }

    func test_SutNotNil() throws {
      XCTAssertNotNil(sut)
    }
  
  func test_GetHeroesSuccess() async throws {
    // Given
    dataSourceMock.shouldThrowError = false
    
    // When
    let result = await sut.getHeroes(from: 0, by: nil)
    
    // Then
  
    XCTAssertEqual(dataSourceMock.getHeroesCount, 1)
    XCTAssertNoThrow(try result.get())
  }
  
  func test_GetHeroesFailure() async throws {
    // Given
    dataSourceMock.shouldThrowError = true
    
    // When
    let result = await sut.getHeroes(from: 0, by: nil)
    
    // Then
    XCTAssertEqual(dataSourceMock.getHeroesCount, 1)
    XCTAssertThrowsError(try result.get())
  }

}

