//
//  GameBoard.swift
//  Connect4
//
//  Created by AT on 5/2/16.
//  Copyright © 2016 AT. All rights reserved.
//

import Foundation


/**
 A simple class that represents a game board for Connect 4

 */
class GameBoard:CustomStringConvertible {

    enum BoardPosition {
        case LeftUp
        case Left
        case LeftDown
        case Up
        case Down
        case RightUp
        case Right
        case RightDown
    }
    
    internal struct Constants {
        
        private struct Dimensions {
            static let Columns: Int = 7
            static let Rows: Int = 6
        }
        
        struct ResultCode {
            static let PieceAdded: Int = 1
            static let Solved: Int = 2
            static let SlotFull: Int = -1
            static let OutOfRange: Int = -2
            static let NoSolution: Int = -3
        }
    }
    
    private lazy var columnHeight:[Int] = {
        return Array(count: Constants.Dimensions.Columns, repeatedValue: Constants.Dimensions.Rows)
    }()
    
    // initialize the board on first use
    private lazy var internalBoard:[[GamePiece]] = {
        var columns:[[GamePiece]] = [[GamePiece]]()
        for r in 1...Constants.Dimensions.Rows {
            var row: [GamePiece] = []
            for c in 1...Constants.Dimensions.Columns {
                row.append(GamePiece())
            }
            columns.append(row)
        }
        return columns
    }()
    
    // not the most efficient way
    // since the string is mutable
    var description: String {
        var desc = ""
        for row in internalBoard {
            desc += "\(row)\n"
        }
        return desc
    }
    
    // MARK: public functions
    
    /**
     Adds a game piece to the first available slot
     
     - Parameter column: The column to add the piece to
     - Parameter color: The color of the piece
     
     - Returns: A result code. Constants.ResultCode
     */
    
    func addGamePiece(column:Int, color: GamePiece.PieceColor)->Int {
        
        if (column >= 0 && column < Constants.Dimensions.Columns) {
            
            var internalRow = columnHeight[column] as Int
            
            if (internalRow > 0) {
                
                internalRow -= 1
                internalBoard[internalRow][column] = GamePiece(color: color)
                columnHeight[column] = internalRow
                
                if (isSolved(internalRow, column: column)) {
                    return Constants.ResultCode.Solved
                }
                
                if isBoardFull() {
                    return Constants.ResultCode.NoSolution
                }
                
                return Constants.ResultCode.PieceAdded
            }
            
            return Constants.ResultCode.SlotFull
        }
        
        return Constants.ResultCode.OutOfRange
    }
    
    /**
     Get a game piece from the board
     
     - Parameter row: The row of the piece
     - Parameter column: The column of the piece

     - Returns: An nil if not found, GamePiece otherwise
     */
    func getGamePiece(row: Int, column:Int) -> Optional<GamePiece> {
            
        if (row >= 0 && row < Constants.Dimensions.Rows) {
            if (column >= 0 && column < Constants.Dimensions.Columns) {
                let gamePiece = internalBoard[row][column] as GamePiece
                return gamePiece
            }
        }

        return nil
    }
    
    /**
     Adds a game piece to a random slot
     
     - Parameter color: The color of the piece
     
     - Returns: A result code. Constants.ResultCode
     */
    func addRandomGamePiece(color: GamePiece.PieceColor)->Int {
        
        let column = Int(arc4random_uniform(UInt32(Constants.Dimensions.Columns)))
        
        return addGamePiece(column, color: color)
    }
    
    // MARK: private functions
    /**
     Is board full
     
     - Returns true if the board has no more slots left
     */
    
    private func isBoardFull()->Bool {
        for height in columnHeight {
            if (height != Constants.Dimensions.Rows) {
                return false
            }
        }
        return true
    }
    
    /**
     Is game solved for a piece
     
     - Parameter row: The row of the piece
     - Parameter column: The column of the piece
     
     - Returns: True if the game is solved
     */
    private func isSolved(row: Int, column:Int)->Bool {
        
        if let gamePiece = getGamePiece(row, column: column) {
            
            if (gamePiece.isEmpty()) {
                return false
            }
            
            print("try to solve for LeftUp, RightDown")
            if countConnected(row, column: column, color: gamePiece.color, boardPositionUp: GameBoard.BoardPosition.LeftUp, boardPositionDown: GameBoard.BoardPosition.RightDown) >= 3 {
                return true
            }
            
            print("try to solve for RightUp, LeftDown")
            if countConnected(row, column: column, color: gamePiece.color, boardPositionUp: GameBoard.BoardPosition.RightUp, boardPositionDown: GameBoard.BoardPosition.LeftDown) >= 3 {
                return true
            }
            
            print("try to solve for Up, Down")
            if countConnected(row, column: column, color: gamePiece.color, boardPositionUp: GameBoard.BoardPosition.Up, boardPositionDown: GameBoard.BoardPosition.Down) >= 3 {
                return true
            }
            
            print("try to solve for Left, Right")
            if countConnected(row, column: column, color: gamePiece.color, boardPositionUp: GameBoard.BoardPosition.Left, boardPositionDown: GameBoard.BoardPosition.Right) >= 3 {
                return true
            }
            
        }
        // go up 3 poistions
        
        return false
    }
    
    
    /**
     Count pieces connected
     
     - Parameter row: The row of the piece to start
     - Parameter column: The column of the piece to start
     - Parameter color: The color of the piece
     - Parameter boardPosition: Direction of counting
                 can be one of 8 possible pieces
                 that can surround a game piece
     
     - Returns: An nil if not found, GamePiece otherwise
     */
    private func countConnected(row: Int, column:Int, color: GamePiece.PieceColor, boardPosition: BoardPosition)->Int {
        
        var count = 0
        
        var (neighborRow, neighborColumn) = getNeighbor(row, column: column, color: color, boardPosition: boardPosition)

        while (isConnected(neighborRow, column: neighborColumn, color: color)) {
            count += 1
            (neighborRow, neighborColumn) = getNeighbor(neighborRow, column: neighborColumn, color: color, boardPosition: boardPosition)
        }
        return count
    }
    
    private func countConnected(row: Int, column:Int, color: GamePiece.PieceColor, boardPositionUp: BoardPosition, boardPositionDown: BoardPosition)->Int {
        
        return countConnected(row, column: column, color: color, boardPosition: boardPositionUp) + countConnected(row, column: column, color: color, boardPosition: boardPositionDown)
    }
    
    private func getNeighbor(row: Int, column:Int, color: GamePiece.PieceColor, boardPosition: BoardPosition)->(Int, Int) {
        
        switch boardPosition {
        case .LeftUp:
            return (row-1, column-1)
        case .Left:
            return (row, column-1)
        case .LeftDown:
            return (row+1, column-1)
        case .Up:
            return (row-1, column)
        case .Down:
            return (row+1, column)
        case .RightUp:
            return (row-1, column+1)
        case .Right:
            return (row, column+1)
        case .RightDown:
            return (row+1, column+1)
        }
    }
    
    private func isConnected(row: Int, column:Int, color: GamePiece.PieceColor)->Bool {
        
        if let gamePiece = getGamePiece(row, column: column) {
            if gamePiece.color == color {
                return true
            }
        }
        
        return false
    }
    
    // MARK: private initializers
    
    init() {
        
    }
    
}