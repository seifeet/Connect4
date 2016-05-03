//
//  Connect4Tests.swift
//  Connect4Tests
//
//  Created by Sei Flavius on 5/2/16.
//  Copyright © 2016 AT. All rights reserved.
//

import XCTest
@testable import Connect4

class Connect4Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testAddingGamePiece() {
        let gameBoard:GameBoard = GameBoard()
        
        gameBoard.addGamePiece(4, color: GamePiece.PieceColor.Red)
        
        let gamePiece = gameBoard.getGamePiece(5, column: 4)! as GamePiece
        
        if (gamePiece.color != GamePiece.PieceColor.Red) {
            XCTFail("Something went with adding a game piece");
        }
    }
    
    func testSolvingAlgorithm() {
        let gameBoard:GameBoard = GameBoard()
        
        gameBoard.addGamePiece(4, color: GamePiece.PieceColor.Red)
        gameBoard.addGamePiece(4, color: GamePiece.PieceColor.Yellow)
        gameBoard.addGamePiece(4, color: GamePiece.PieceColor.Red)
        gameBoard.addGamePiece(4, color: GamePiece.PieceColor.Yellow)
        gameBoard.addGamePiece(4, color: GamePiece.PieceColor.Red)
        
        gameBoard.addGamePiece(0, color: GamePiece.PieceColor.Yellow)
        gameBoard.addGamePiece(1, color: GamePiece.PieceColor.Yellow)
        gameBoard.addGamePiece(2, color: GamePiece.PieceColor.Yellow)
        gameBoard.addGamePiece(2, color: GamePiece.PieceColor.Yellow)
        
        let result = gameBoard.addGamePiece(3, color: GamePiece.PieceColor.Yellow)
        
        if (result != GameBoard.Constants.ResultCode.Solved) {
            XCTFail("Something went wrong with testSolvingAlgorithm");
        }
    }
    
    func testPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            let gameBoard:GameBoard = GameBoard()
            
            while (1==1) {
                let resultRed = gameBoard.addRandomGamePiece(GamePiece.PieceColor.Red)
                
                if (resultRed == GameBoard.Constants.ResultCode.NoSolution) {
                    break
                } else if (resultRed == GameBoard.Constants.ResultCode.Solved) {
                    break
                }
                
                let resultYellow = gameBoard.addRandomGamePiece(GamePiece.PieceColor.Yellow)
                
                if (resultYellow == GameBoard.Constants.ResultCode.NoSolution) {
                    break
                } else if (resultYellow == GameBoard.Constants.ResultCode.Solved) {
                    break
                }
            }
        }
    }
    
}
