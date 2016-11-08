//
//  ViewController.swift
//  TicTacToeDemo
//
//  Created by Lab kumar on 09/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardViewDelegate {
    var boardView: BoardView = BoardView()
    var gameOver = false
    var info: UILabel = UILabel()
    var restartButton: UIButton = UIButton()
    
    var currentMoveBy: Board.PlayerType = .Player1   // let player 1 start for the first time
    
    override func viewDidLoad() {
        // Create view
        super.viewDidLoad()
        
        view.autoresizesSubviews = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        boardView = BoardView()
        boardView.delegate = self
        boardView.backgroundColor = UIColor.white
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        info = UILabel()
        info.text = "Welcome Players !!!"
        info.numberOfLines = 0
        info.setContentCompressionResistancePriority(100, for: UILayoutConstraintAxis.horizontal)
        info.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(info)
        
        restartButton = UIButton()
        restartButton.setTitle("New Game", for: UIControlState())
        restartButton.setTitleColor(UIColor.blue, for: UIControlState())
        restartButton.addTarget(self, action: #selector(ViewController.restart), for: .touchUpInside)
        
        // Swift bug, Xcode 6.3. Cannot use priority constant, needs to be value
        restartButton.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.horizontal)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(restartButton)
        
        let viewsDictionary = ["info": info, "button": restartButton, "board": boardView] as [String : Any]
        let visualConstraints = [
            "H:|-(>=10)-[board]-(>=10)-|",
            "V:|-30-[button]-[board]-30-|",
            "H:|-[info]-(>=8)-[button]-|",
            "V:|-30-[info]-[board]-30-|"]
        
        let constraints = getVisualConstraintArray(vcArray: visualConstraints, options: [], metrics: nil, viewDictionary: viewsDictionary as [String : AnyObject])
        
        // Constrain board to be square
        let aspectRatio = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.height,
                                             relatedBy: NSLayoutRelation.equal, toItem: boardView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)
        boardView.addConstraint(aspectRatio)
        
        // Constrain board to be centered relative to parent view
        let constraint = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        view.addConstraints(constraints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func restart() {
        boardView.board = Board()
        boardView.setNeedsDisplay()
        info.text = "New game started"
        gameOver = false
    }
    
    // Utility method: Add set array of visual constraints using same view and view dictionary
    func getVisualConstraintArray(vcArray: [String], options opts: NSLayoutFormatOptions, metrics: [String: AnyObject]?,
                                  viewDictionary: [String: AnyObject]) -> [NSLayoutConstraint] {
        var result = [NSLayoutConstraint]()
        for visualConstraint in vcArray {
            let newConstraints = NSLayoutConstraint.constraints(withVisualFormat: visualConstraint,
                                                                options: opts, metrics: metrics, views: viewDictionary)
            result += newConstraints
        }
        return result
    }
    
    func nextMoveBy () -> Board.PlayerType {
        if currentMoveBy == .Player1 {
            return .Player2
        } else if currentMoveBy == .Player2 {
            return .Player1
        }
        
        return .Nobody
    }
    
    //MARK: Delegate method
    // Called by boardView when player has moved
    func playerMoved(_ playerMove: Int) {
        if gameOver {
            return
        }
        
        let status = boardView.board.move(playerMove, player: currentMoveBy)
        
        if status != .invalid {
            boardView.setNeedsDisplay()
        }
        switch status {
        case .Player1Won:
            info.text = "\(currentMoveBy.rawValue) Won"
            gameOver = true
        case .Player2Won:
            info.text = "\(currentMoveBy.rawValue) Won"
            gameOver = true
        case .draw:
            info.text = "Draw"
            gameOver = true
        case .invalid:
            info.text = "Space is occupied"
        case .valid:
            currentMoveBy = nextMoveBy()
            print("valid move")
        }
        
        self.boardView.setNeedsDisplay()
    }
}

