//
//  GetHeroDataTests.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 7/3/25.
//

import XCTest
@testable import WallaMarvel

final class GetHeroDataTests: XCTestCase {

  var sut: GetHeroData!
  var repositoryMock: MarvelRepositoryMock!
  
  override func setUpWithError() throws {
    repositoryMock = MarvelRepositoryMock()
    sut = GetHeroData(repository: repositoryMock)
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
    let expectedResponse: PaginatedResponse<HeroData> = PaginatedResponse(
      offset: 0,
      limit: 0,
      total: 0,
      count: 0,
      results: [.init(
        id: 1,
        title: "Spiderman",
        thumbnailURL: URL(string: "https://www.url.com")!
      )]
    )
    repositoryMock.shouldThrowError = false
    let result = try await sut.execute(by: 0, from: 0, type: .comic)
    
    XCTAssertEqual(result, expectedResponse)
    XCTAssertEqual(repositoryMock.getHeroDataCount, 1)
  }
  
  func testExecuteFailure() async throws {
    // Given
    repositoryMock.shouldThrowError = true
    
    do {
      // When
      _ = try await sut.execute(by: 0, from: 0, type: .comic)
      XCTFail("La función no lanzó un error cuando debía hacerlo")
    } catch {
      // Then
      XCTAssertEqual(error as? URLError, URLError(.badServerResponse))
    }
    
    XCTAssertEqual(repositoryMock.getHeroDataCount, 1)
  }
}

