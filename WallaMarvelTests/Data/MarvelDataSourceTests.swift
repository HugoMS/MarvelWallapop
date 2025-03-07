//
//  MarvelDataSourceTests.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 7/3/25.
//

import XCTest
@testable import WallaMarvel

final class MarvelDataSourceTests: XCTestCase {

  var sut: MarvelDataSource!
  var clientMock: APIClientMock!
  
    override func setUpWithError() throws {
      clientMock = APIClientMock()
       sut = MarvelDataSource(apiClient: clientMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

  func test_SutNotNil() throws {
    XCTAssertNotNil(sut)
  }
  
  func test_GetHeroesSuccess() async throws {
    
    // When
    let result = try await sut.getHeroes(from: 0, by: nil)
    
    // Then
    
    XCTAssertEqual(clientMock.getHeroesCount, 1)
    XCTAssertNoThrow(result)
  }
  
  func test_GetHeroDataSuccess() async throws {
    
    // When
    let result = try await sut.getHeroData(by: 0, from: 0, type: .comic)
    
    // Then
    
    XCTAssertEqual(clientMock.getHeroDataCount, 1)
    XCTAssertNoThrow(result)
  }
  

}
