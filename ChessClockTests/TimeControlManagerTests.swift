//
//  TimeControlManagerTests.swift
//  ChessClockTests
//
//  Created by Keith Staines on 30/12/2021.
//

import XCTest
@testable import ChessClock

class TimeControlManagerTests: XCTestCase {
    
    let testDefinitions: [TimeControlDefinition] = [
        .init(numberOfMoves: 10, interval: 1800, increment: 10),
        .init(numberOfMoves: 10, interval: 1800, increment: 10),
        .init(numberOfMoves: 10, interval: 1800, increment: 10),
    ]
    
    let testControls = [
        TimeControl(firstMoveNumber: 1, lastMoveNumber: 10, interval: 1800, increment: 10),
        TimeControl(firstMoveNumber: 11, lastMoveNumber: 20, interval: 1800, increment: 10),
        TimeControl(firstMoveNumber: 21, lastMoveNumber: 30, interval: 1800, increment: 10)
    ]

    func testInit_with_time_controls() {
        let sut = TimeControlManager(testDefinitions)
        XCTAssertEqual(sut.timeControls.count, testDefinitions.count)
        XCTAssertEqual(sut.timeControls, testControls)
    }
    
    func test_insertDefinition() {
        let sut = TimeControlManager()
        sut.insertDefinition(testDefinitions[1], at: 0)
        sut.insertDefinition(testDefinitions[0], at: 0)
        sut.insertDefinition(testDefinitions[2], at: 2)
        XCTAssertEqual(sut.timeControls.count, testDefinitions.count)
        XCTAssertEqual(sut.timeControls, testControls)
    }
    
    func test_appendDefinition() {
        let sut = TimeControlManager()
        sut.appendDefinition(testDefinitions[0])
        sut.appendDefinition(testDefinitions[1])
        sut.appendDefinition(testDefinitions[2])
        XCTAssertEqual(sut.timeControls.count, testDefinitions.count)
        XCTAssertEqual(sut.timeControls, testControls)
    }
}
