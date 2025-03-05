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
    let result = try await sut.getHeroes(from: 0, by: nil)
    
    // Then
  
    XCTAssertEqual(dataSourceMock.getHeroesCount, 1)
    XCTAssertNoThrow(result)
  }

  
  func test_GetHeroesFailure() async {
    // Given
    dataSourceMock.shouldThrowError = true
    
    do {
      // When
      _ = try await sut.getHeroes(from: 0, by: nil)
      XCTFail("La función no lanzó un error cuando debía hacerlo")
    } catch {
      // Then
      XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
    }
    
    XCTAssertEqual(dataSourceMock.getHeroesCount, 1)
  }

}
