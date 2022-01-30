//
//  LibraryTests.swift
//  ChessClockTests
//
//  Created by Keith Staines on 29/01/2022.
//

import XCTest
@testable import ChessClock

class LibraryTests: XCTestCase {
    
    func test_loadFromBundle() {
        let library = Bundle.main.decode(Library.self, from: "Library.json")
        XCTAssertEqual(library.gameDefinitions.count, 13)
    }
}
