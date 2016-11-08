//
//  BoardController.swift
//  TicTacToeDemo
//
//  Created by Lab kumar on 09/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation

class Board {
    init() {}
    
    var handleForWinningPattern: (([Int]) -> Void)?
    
    init(copy: Board) {
        boardPositionArray = copy.boardPositionArray
    }
    
    enum PlayerType: String {
        case Player1 = "Player 1"
        case Player2 = "Player 2"
        case Nobody = "Nobody"
    }
    
    enum BoardState {
        case Player1Won
        case Player2Won
        case draw
        case invalid
        case valid
    }
    
    // Note that setting board is set by value, ie a copy is made of the array
    var boardPositionArray: [PlayerType] = [PlayerType](repeating: .Nobody, count: 9)
    
    func move(_ newMove: Int, player: PlayerType) -> BoardState {
        var result: BoardState = .valid
        if !isValidMove(newMove) {
            result = .invalid
        } else {
            boardPositionArray[newMove] = player
            if hasWon(.Player1) {
                result = .Player1Won
            } else if hasWon(.Player2) {
                result = .Player2Won
            } else if isDraw() {
                result = .draw
            }
        }
        
        return result
    }
    
    func hasWon(_ player: PlayerType) -> Bool {
        let winningPatterns = [
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
            [1, 4, 7],
            [2, 5, 8],
            [3, 6, 9],
            [1, 5, 9],
            [3, 5, 7]]
        // Iterate through winning patterns
        var hasWon = true
        _ = 0
        for pattern in winningPatterns {
            hasWon = true
            for i in pattern {
                hasWon = hasWon && (boardPositionArray[i-1] == player)
                if !hasWon {
                    break
                }
            }
            if hasWon == true {
                print("Winning Pattern \(pattern)")
                handleForWinningPattern?(pattern)
                break
            }
        }
        
        return hasWon
    }
    
    func isDraw() -> Bool {
        var result = true
        for i in 0...8 {
            if boardPositionArray[i] == .Nobody {
                result = false
                break
            }
        }
        return result
    }
    
    func isValidMove(_ move: Int) -> Bool {
        return boardPositionArray[move] == .Nobody
    }
}
