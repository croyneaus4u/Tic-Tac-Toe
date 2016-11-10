//
//  Utility.swift
//  TicTacToeDemo
//
//  Created by Lab kumar on 09/11/16.
//  Copyright © 2016 Lab kumar. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func addAttributesFor (partText: String, fullText: String, attributes: [String: AnyObject]) {
        
        let combinedString = fullText as NSString
        let range = combinedString.range(of: partText)        
        addAttributes(attributes, range: range)
    }
}
