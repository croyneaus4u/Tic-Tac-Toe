//
//  BoardView.swift
//  TicTacToeDemo
//
//  Created by Lab kumar on 09/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

protocol BoardViewDelegate {
    func playerMoved(_ playerMove: Int)
    func boardStrokeColor () -> UIColor?
    func player1Color () -> UIColor?
    func player2Color () -> UIColor?
    func winningBlockColor () -> UIColor?
}

class BoardView: UIView {

    var board: Board = Board()
    var delegate: BoardViewDelegate?
    
    let padding: CGFloat = 15.0
    
    var side: CGFloat = 0
    var squareSize: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        let width = bounds.width
        let height = bounds.height
        side = min(width, height)
        squareSize = side/3
        
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(0.5)
        context.setLineCap(CGLineCap.round)
        
        let color = UIColor.init(colorLiteralRed: 77/255.0, green: 70/255.0, blue: 64/255.0, alpha: 1.0)
        color.set()
        context.fill(rect)
        
        var boardStrokes = [[CGFloat]]() // Respresents the 4 points of the square
        
        if let winningPattern = board.winningPattern {
            for pos in winningPattern {
                draw_BOX(pos-1, context: context)
            }
        }
        
        for i in 1...2 {
            // Draw vertical line
            var startX: CGFloat = squareSize * CGFloat(i)
            var startY: CGFloat = 0
            var endX: CGFloat = startX
            var endY: CGFloat = side
            boardStrokes.append([startX, startY, endX, endY])
            
            // Draw horizontal line
            startX = 0
            startY = squareSize * CGFloat(i)
            endX = side
            endY = startY
            boardStrokes.append([startX, startY, endX, endY])
        }
        
        let boardStrokeColor = delegate?.boardStrokeColor() ?? UIColor.black
        boardStrokeColor.set()
        for stroke in boardStrokes {
            context.move(to:CGPoint(x:stroke[0], y:stroke[1]))
            context.addLine(to:CGPoint(x:stroke[2], y:stroke[3]))
            context.strokePath()
        }
        
        context.setLineWidth(10.0)
        var X_Strokes = [[CGFloat]]()
        
        for move in 0...8 {
            switch board.boardPositionArray[move] {
            case .Player2:
                X_Strokes += draw_X(move)
            case .Player1:
                draw_O(move, context: context)
            default: ()
            }
        }
        
        for stroke in X_Strokes {
            let player2Color = delegate?.player2Color() ?? UIColor.black
            player2Color.set()
            context.move(to:CGPoint(x:stroke[0], y:stroke[1]))
            context.addLine(to:CGPoint(x:stroke[2], y:stroke[3]))
            context.strokePath()
        }
    }
    
    func draw_X(_ position: Int) -> [[CGFloat]] {
        var strokes = [[CGFloat]]()
        let row = position/3
        let col = position % 3
        
        let startX = padding + CGFloat(col) * squareSize
        let endX   = startX + squareSize - 2 * padding
        
        let startY = padding + CGFloat(row) * squareSize
        let endY   = startY + squareSize - 2 * padding
        
        strokes.append([startX, startY, endX, endY])
        strokes.append([endX, startY, startX, endY])
        return strokes
    }
    
    func draw_O(_ position: Int, context: CGContext) {
        let player1Color = delegate?.player1Color() ?? UIColor.black
        player1Color.set()
        let xStrokes = draw_X(position)
        let stroke = xStrokes[0]
        let rect = CGRect(x: stroke[0], y: stroke[1],
            width: stroke[2] - stroke[0],  
            height: stroke[2] - stroke[0])
        context.addEllipse(in: rect)
        context.strokePath()
    }
    
    func draw_BOX(_ position: Int, context: CGContext) {
        
        let winningColor = delegate?.winningBlockColor() ?? UIColor.green.withAlphaComponent(0.1)
        winningColor.set()
        let xStrokePonts = draw_X(position)
        let stroke = xStrokePonts[0]
        var rect = CGRect(x: stroke[0], y: stroke[1],
                          width: stroke[2] - stroke[0],
            height: stroke[2] - stroke[0])
        
        rect = rect.insetBy(dx: -padding, dy: -padding)
        
        context.fill(rect)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            if let point = touches.first?.location(in: self) {
                let playerMove = convertCGPointToPosition(point)
                delegate?.playerMoved(playerMove)
            }
        }
    }
    
    func convertCGPointToPosition(_ point: CGPoint) -> Int {
        let col: Int = Int(point.x / squareSize)
        let row: Int = Int(point.y / squareSize)
        let position = row * 3 + col
        return position
    }
}
