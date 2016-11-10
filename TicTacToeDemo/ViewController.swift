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
    
    
    
    var currentMoveBy: Board.PlayerType = .Player1 {
        didSet {
            setMoveText()
        }
    }
    
    var player1WInCount: Int = 0
    var player2WInCount: Int = 0
    var drawCount: Int = 0
    
    var restartButton: UIButton = UIButton()
    var moveLabel = UILabel()
    let winLabel = UILabel()
    
    let paginator: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 6
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.tintColor = UIColor.gray
        pageControl.backgroundColor = UIColor.red
        
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.gray
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.autoresizesSubviews = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let color = UIColor.init(colorLiteralRed: 77/255.0, green: 70/255.0, blue: 64/255.0, alpha: 1.0)
        view.backgroundColor = color
        
        boardView = BoardView()
        boardView.delegate = self
        boardView.backgroundColor = UIColor.white
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        
        moveLabel.translatesAutoresizingMaskIntoConstraints = false
        moveLabel.textColor = baseColor()
        setMoveText()
        moveLabel.textAlignment = .center
        moveLabel.font = UIFont.init(name: "Avenir-Medium", size: 25.0)
        moveLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        view.addSubview(moveLabel)
        
        winLabel.translatesAutoresizingMaskIntoConstraints = false
        winLabel.textAlignment = .center
        winLabel.numberOfLines = 2
        winLabel.textColor = UIColor.white
        winLabel.font = UIFont.init(name: "Avenir-Heavy", size: 30.0)
        winLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        setWinText(.draw)
        view.addSubview(winLabel)
        
        restartButton = UIButton()
        restartButton.setTitle("New Game", for: UIControlState())
        restartButton.setTitleColor(baseColor(), for: UIControlState())
        restartButton.titleLabel?.font = UIFont.init(name: "Avenir-Medium", size: 20.0)!
        restartButton.addTarget(self, action: #selector(ViewController.restart), for: .touchUpInside)
        
        restartButton.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(restartButton)
        
        let viewsDictionary = ["moveLabel": moveLabel, "button": restartButton, "board": boardView, "winLabel": winLabel] as [String : Any]
        
        let visualConstraints = [
            "H:|-(>=10)-[board]-(>=10)-|",
            "V:|-40-[moveLabel]-20-[board]-30-[winLabel]-10-[button]-20-|",
            "H:|-[moveLabel]-|",
            "H:|-[button]-|",
            "H:|-[winLabel]-|"]

        
        let constraints = getVisualConstraintArray(vcArray: visualConstraints, options: [], metrics: nil, viewDictionary: viewsDictionary as [String : AnyObject])
        
        let aspectRatio = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.height,
                                             relatedBy: NSLayoutRelation.equal, toItem: boardView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.0)
        boardView.addConstraint(aspectRatio)
        
        let constraint = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        view.addConstraint(constraint)
        let constraintV = NSLayoutConstraint(item: boardView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        view.addConstraint(constraintV)
        view.addConstraints(constraints)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func restart() {
        boardView.board = Board()
        boardView.setNeedsDisplay()
        gameOver = false
        setMoveText()
    }
    
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
    
    func colorFor (_ player: Board.PlayerType) -> UIColor {
        switch player {
        case .Player1:
            return player1Color() ?? UIColor.white
        case .Player2:
            return player2Color() ?? UIColor.white
        case .Nobody:
            return UIColor.white
        }
    }
    
    func setMoveText () {
        let partText = "\(currentMoveBy.rawValue)"
        let fullText = "\(partText) to move"
        let fullAttributedText = NSMutableAttributedString(string: fullText)
        
        let color = colorFor(currentMoveBy)
        
        fullAttributedText.addAttributesFor(partText: partText, fullText: fullText, attributes: [NSForegroundColorAttributeName: color])
        moveLabel.attributedText = fullAttributedText
    }
    
    func setWinText (_ result: Board.BoardState) {
        
        var color = colorFor(.Player1)
        let p1AttrString = NSAttributedString(string: "\(player1WInCount)", attributes: [NSForegroundColorAttributeName: color])
        
        color = colorFor(.Player2)
        let p2AttrString = NSAttributedString(string: "\(player2WInCount)", attributes: [NSForegroundColorAttributeName: color])
        
        color = colorFor(.Nobody)
        let drawAttrString = NSAttributedString(string: "\(drawCount)", attributes: [NSForegroundColorAttributeName: color])
        
        let separator = NSAttributedString(string: " : ", attributes: [NSForegroundColorAttributeName: baseColor()])
        let fullAttributedString = NSMutableAttributedString(attributedString: p1AttrString)
        fullAttributedString.append(separator)
        fullAttributedString.append(drawAttrString)
        fullAttributedString.append(separator)
        fullAttributedString.append(p2AttrString)
        
        winLabel.attributedText = fullAttributedString
        
        if result != .draw {
            moveLabel.text = "\(currentMoveBy.rawValue) won"
        }
    }
    
    func baseColor () -> UIColor {
        return UIColor.lightGray
    }
    
    //MARK: Delegate method
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
            player1WInCount += 1
            gameOver = true
            setWinText(status)
        case .Player2Won:
            player2WInCount += 1
            gameOver = true
            setWinText(status)
        case .draw:
            moveLabel.text = "Draw"
            drawCount += 1
            gameOver = true
            setWinText(status)
        case .invalid:
            moveLabel.text = "Invalid Move."
        case .valid:
            currentMoveBy = nextMoveBy()
        }
        
        self.boardView.setNeedsDisplay()
    }
    
    func boardStrokeColor() -> UIColor? {
        return baseColor()
    }
    
    func player1Color() -> UIColor? {
        return UIColor.init(colorLiteralRed: 142/255.0, green: 192/255.0, blue: 231/255.0, alpha: 1.0)
    }
    
    func player2Color() -> UIColor? {
        return UIColor.init(colorLiteralRed: 227/255.0, green: 214/255.0, blue: 130/255.0, alpha: 1.0)
    }
    
    func winningBlockColor() -> UIColor? {
        return UIColor.green.withAlphaComponent(0.1)
    }
}

