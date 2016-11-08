//
//  TicTacToeDemoTests.swift
//  TicTacToeDemoTests
//
//  Created by Lab kumar on 09/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import XCTest
@testable import TicTacToeDemo

class TicTacToeDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testForWinTopRow () {
        let board = Board()
        board.boardPositionArray = [.Player1, .Player1, .Player1, .Nobody, .Nobody, .Nobody,  .Nobody, .Nobody, .Nobody]
        XCTAssert(board.hasWon(.Player1), "Pass")
    }
    
    func testWinLeftCol () {
        let board = Board()
        board.boardPositionArray = [
            .Player1, .Player2, .Player2,
            .Player1, .Nobody, .Nobody,
            .Player1, .Player2, .Player2]
        XCTAssertTrue(board.hasWon(.Player1), "Pass")
    }
    
    func testDiagonalWin () {
        let board = Board()
        board.boardPositionArray = [
            .Player1, .Player2, .Player2,
            .Nobody, .Player1, .Nobody,
            .Player1, .Player2, .Player1]
        XCTAssertTrue(board.hasWon(.Player1), "Pass")
    }
    
    func testNotWin () {
        let board = Board()
        board.boardPositionArray = [.Player1, .Player1, .Player2, .Nobody, .Nobody, .Nobody,  .Nobody, .Nobody, .Nobody]
        XCTAssert(!board.hasWon(.Player1), "Pass")
    }
    
    func testDraw () {
        let board = Board()
        board.boardPositionArray = [.Player2, .Player2, .Player1,  .Player1, .Player1, .Player2,  .Player2, .Player1, .Player1]
        XCTAssert(board.isDraw(), "Pass")
        XCTAssert(!board.hasWon(.Player1), "Pass")
    }
    
}
