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
    XCTAssertEqual(viewMock.showEmptyCount, 1)
    
  }
  
  
  func test_loadMoreCharactersIfNeededNextPage() async {
    let executeResult: PaginatedResponse<Character> = .init(offset: 0, limit: 20, total: 21, count: 1, results: [.init(id: 1, name: "Hulk", description: "Strongest Avenger", thumbnailURL: nil)])
    useCaseMock.shouldThrowError = false
    useCaseMock.executeResult = executeResult
    
    await sut.getHeroes(from: 0)
    XCTAssertEqual(useCaseMock.executeCount, 1)
    XCTAssertEqual(viewMock.updateCount, 1)
    
    await sut.loadMoreCharactersIfNeeded()
    
    XCTAssertEqual(useCaseMock.executeCount, 2)
    XCTAssertEqual(viewMock.updateCount, 2)
    XCTAssertEqual(viewMock.showEmptyCount, 0)
  }
  
  func test_loadMoreCharactersIfNeededNoMorePages() async {
    let executeResult: PaginatedResponse<Character> = .init(offset: 0, limit: 1, total: 1, count: 1, results: [.init(id: 1, name: "Hulk", description: "Strongest Avenger", thumbnailURL: nil)])
    useCaseMock.shouldThrowError = false
    useCaseMock.executeResult = executeResult
    
    await sut.getHeroes(from: 0)
    XCTAssertEqual(useCaseMock.executeCount, 1)
    XCTAssertEqual(viewMock.updateCount, 1)
    
    await sut.loadMoreCharactersIfNeeded()
    
    XCTAssertEqual(useCaseMock.executeCount, 1)
    XCTAssertEqual(viewMock.updateCount, 1)
    XCTAssertEqual(viewMock.finishPaginationCount, 1)
  }
  
}
