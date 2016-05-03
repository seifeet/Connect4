//
//  ViewController.swift
//  Connect4
//
//  Created by AT on 5/2/16.
//  Copyright © 2016 AT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var labelView: UILabel!
    let gameBoard:GameBoard = GameBoard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        while (1==1) {
            let resultRed = gameBoard.addRandomGamePiece(GamePiece.PieceColor.Red)
            
            if (resultRed == GameBoard.Constants.ResultCode.NoSolution) {
                self.labelView.text = "No Solution!"
                break
            } else if (resultRed == GameBoard.Constants.ResultCode.Solved) {
                self.labelView.text = "Solved! Red is the Winner!"
                break
            }
            
            let resultYellow = gameBoard.addRandomGamePiece(GamePiece.PieceColor.Yellow)
            
            if (resultYellow == GameBoard.Constants.ResultCode.NoSolution) {
                self.labelView.text = "No Solution!"
                break
            } else if (resultYellow == GameBoard.Constants.ResultCode.Solved) {
                self.labelView.text = "Solved! Yellow is the Winner!"
                break
            }
        }
        
        self.textView.text = gameBoard.description
    }

}

