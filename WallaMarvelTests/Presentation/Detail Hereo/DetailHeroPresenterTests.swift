//
//  DetailHeroPresenterTests.swift
//  WallaMarvelTests
//
//  Created by Hugo Morelli on 5/3/25.
//

import XCTest
@testable import WallaMarvel

final class DetailHeroPresenterTests: XCTestCase {

  // MARK: - Properties -
  
  var sut: DetailHeroPresenter!
  var useCaseMock: GetHeroDataUseCaseMock!
  var viewMock: DetailHeroUIMock!
  
  @MainActor override func setUpWithError() throws {
    useCaseMock = GetHeroDataUseCaseMock()
    viewMock = DetailHeroUIMock()
    sut = DetailHeroPresenter(character: .init(id: 1, name: "Iron Man"), getHereoDataUseCase: useCaseMock)
    sut.inject(ui: viewMock)
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
  
  func test_getHeroDetails() {
    let heroDetails = sut.getHeroDetails()
    XCTAssertEqual(heroDetails.hero.id, 1)
    XCTAssertEqual(heroDetails.hero.name, "Iron Man")
    XCTAssertEqual(heroDetails.comics, [])
    XCTAssertEqual(heroDetails.events, [])
    XCTAssertEqual(heroDetails.series, [])
    XCTAssertEqual(heroDetails.stories, [])
    XCTAssertEqual(heroDetails.loader, false)
  }
  
  func test_getCharacter() {
    let expectedCharacter: Character = .init(id: 1, name: "Iron Man")
    let character = sut.getCharacter()
    XCTAssertEqual(character, expectedCharacter)
  }
  
  func test_screenTitle() {
    let expectedTitle = "Hero Detail"
    let title = sut.screenTitle()
    XCTAssertEqual(title, expectedTitle)
    
  }
}
