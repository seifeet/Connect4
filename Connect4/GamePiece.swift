//
//  GamePiece.swift
//  Connect4
//
//  Created by Sei Flavius on 5/2/16.
//  Copyright © 2016 AT. All rights reserved.
//

import Foundation

/**
 A simple class that represents a game piece for Connect 4
 
 */

class GamePiece:CustomStringConvertible {

    enum PieceColor {
        case Empty
        case Yellow
        case Red
    }
    
    var color: PieceColor
    
    // may be should have position too (row, column)
    // but for now keeping it simple
    
    func isEmpty() -> Bool {
        return self.color == PieceColor.Empty
    }
    
    var description: String {
        switch color {
        case .Empty:
            return "-"
        case .Yellow:
            return "Y"
        case .Red:
            return "R"
        }
    }
    
    init() {
        self.color = PieceColor.Empty
    }
    
    init(color: PieceColor) {
        self.color = color
    }
}
