//
//  FiveByFiveState.swift
//  XO-game
//
//  Created by Константин Шмондрик on 25.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class FiveByFiveState: GameState {

    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    public let markViewPrototype: MarkView
    
    var counter = 0
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
            self.gameViewController?.firstPlayerTurnLabel.text = self.playerName(from: player)
        case .second, .computer:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.text = self.playerName(from: player)
        }

        gameViewController?.winnerLabel.isHidden = true
    }

    func addMark(at position: GameboardPosition) {
        Log(.playerInput(player: self.player, position: position))

        guard let gameBoardView = gameboardView,
              gameBoardView.canPlaceMarkView(at: position) else {
            return
        }

        gameboard?.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markViewPrototype.copy(), at: position)
        
        if player == .first {
            GameSession.shared.playerFirstMoves.append(PlayerMove(player: .first, position: position))
        } else {
            GameSession.shared.playerSecondMoves.append(PlayerMove(player: .second, position: position))
        }
        
        counter += 1
        
        if counter >= 5 {
            isCompleted = true
        }
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
}
