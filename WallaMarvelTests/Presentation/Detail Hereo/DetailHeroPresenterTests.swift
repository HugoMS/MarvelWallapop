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
}
