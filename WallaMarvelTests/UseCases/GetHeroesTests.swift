//
//  GetHeroesTests.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import XCTest
@testable import WallaMarvel

final class GetHeroesTests: XCTestCase {
  
  var sut: GetHeroes!
  var repositoryMock: MarvelRepositoryMock!
  
  override func setUpWithError() throws {
    repositoryMock = MarvelRepositoryMock()
    sut = GetHeroes(repository: repositoryMock)
  }
  
  override func tearDownWithError() throws {
    sut = nil
    repositoryMock = nil
    try super.tearDownWithError()
  }
  
  func test_SutNotNil() throws {
    XCTAssertNotNil(sut)
  }
  
  func testExecuteSuccess() async throws {
    let expectedResponse: PaginatedResponse<Character> = PaginatedResponse(offset: 0, limit: 1, total: 1, count: 1, results: [ .init(id: 1, name: "Spiderman", description: "Spiderman description")])
    repositoryMock.shouldThrowError = false
    let result = try await sut.execute(from: 0, by: nil)
    
    XCTAssertEqual(result, expectedResponse)
    XCTAssertEqual(repositoryMock.getHeroesCount, 1)
  }
  
  func testExecuteFailure() async throws {
    let expectedResponse: PaginatedResponse<Character> = PaginatedResponse(offset: 0, limit: 1, total: 1, count: 1, results: [ .init(id: 1, name: "Spiderman", description: "Spiderman description")])
    // Given
    repositoryMock.shouldThrowError = true
    
    do {
      // When
      _ = try await sut.execute(from: 0, by: nil)
      XCTFail("La función no lanzó un error cuando debía hacerlo")
    } catch {
      // Then
      XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
    }
    
    XCTAssertEqual(repositoryMock.getHeroesCount, 1)
  }
}
