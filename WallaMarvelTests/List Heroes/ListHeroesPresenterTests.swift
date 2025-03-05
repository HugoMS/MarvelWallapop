//
//  ListHeroesPresenterTests.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import XCTest
@testable import WallaMarvel

final class ListHeroesPresenterTests: XCTestCase {
  // MARK: - Properties -
  
  var sut: ListHeroesPresenter!
  var useCaseMock: GetHeroesUseCaseMock!
  var viewMock: ListHeroesUIMock!
  
  override func setUpWithError() throws {
    useCaseMock = GetHeroesUseCaseMock()
    viewMock = ListHeroesUIMock()
    sut = ListHeroesPresenter(getHeroesUseCase: useCaseMock)
    sut.ui = viewMock
  }
  
  override func tearDownWithError() throws {
    useCaseMock = nil
    viewMock = nil
    sut = nil
    try super.tearDownWithError()
    
  }
  
  func test_SUTNotNil() throws {
    XCTAssertNotNil(sut)
  }
  
  func test_GetHeroesSuccess() async throws {
    useCaseMock.shouldThrowError = false
    
    // When
    await sut.getHeroes(from: 0)
    
    // Then
    
    XCTAssertEqual(useCaseMock.executeCount, 1)
    XCTAssertEqual(viewMock.updateCount, 1)
  
  }
  
  func test_GetHeroesFailure() async throws {
    useCaseMock.shouldThrowError = true
    
    // When
    await sut.getHeroes(from: 0)
    
    // Then
    
    XCTAssertEqual(useCaseMock.executeCount, 1)
    XCTAssertEqual(viewMock.updateCount, 0)
    
  }
  
}
