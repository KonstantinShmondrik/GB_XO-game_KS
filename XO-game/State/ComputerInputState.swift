//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Константин Шмондрик on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public class ComputerInputState: GameState {
  
    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    public let markViewPrototype: MarkView
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
            self.gameViewController?.firstPlayerTurnLabel.text = self.playerName(from: player)
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.text = self.playerName(from: player)
        case .computer:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.text = self.playerName(from: player)
        }
       
        if let position = calculatePosition() {
            addMark(at: position)
        }
        
        self.gameViewController?.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        Log(.playerInput(player: self.player, position: position))
        
        guard let gameboardView = self.gameboardView
                , gameboardView.canPlaceMarkView(at: position)
        else { return }
        
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(self.markViewPrototype.copy(), at: position)
        self.isCompleted = true
    }
    
    private func playerName(from player: Player) -> String {
        switch player {
        case .first:
            return "1st player"
        case .second:
            return "2nd player"
        case .computer:
            return "computer"
        }
    }
    
    private func calculatePosition() -> GameboardPosition? {
        var positions: [GameboardPosition] = []

        for column in 0...GameboardSize.columns - 1 {
            for row in 0...GameboardSize.rows - 1 {
                let position = GameboardPosition(column: column, row: row)
                if gameboardView!.canPlaceMarkView(at: position) {
                    positions.append(position)
                }
            }
        }
        
        return positions.randomElement()
    }
    
}
