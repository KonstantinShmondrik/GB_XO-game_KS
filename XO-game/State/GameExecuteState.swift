//
//  GameExecuteState.swift
//  XO-game
//
//  Created by Константин Шмондрик on 25.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class GameExecuteState: GameState {
   
    var isCompleted: Bool = false
  
    private weak var gameViewController: GameViewController?
    private weak var gameboard: Gameboard?
    private weak var gameboardView: GameboardView?
    private var player: Player = .first
    private var timer: Timer?
    
    var completionHandler: () -> Void
    
    init(gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView, _ completionHandler: @escaping () -> Void) {
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.completionHandler = completionHandler
    }
    
    @objc func performMove() {
        if GameSession.shared.playerFirstMoves.count > 0 || GameSession.shared.playerSecondMoves.count > 0 {
            var move: PlayerMove?
            
            if player == .first {
                move = GameSession.shared.playerFirstMoves.removeFirst()
                gameViewController?.firstPlayerTurnLabel.isHidden = false
                gameViewController?.secondPlayerTurnLabel.isHidden = true
                self.gameViewController?.firstPlayerTurnLabel.text = self.playerName(from: player)
                
            } else {
                move = GameSession.shared.playerSecondMoves.removeFirst()
                gameViewController?.firstPlayerTurnLabel.isHidden = true
                gameViewController?.secondPlayerTurnLabel.isHidden = false
                self.gameViewController?.secondPlayerTurnLabel.text = self.playerName(from: player)
            }
            
            if let move = move {
                addMark(at: move.position)
                player = player.next
            }
            
        } else {
            timer?.invalidate()
            completionHandler()
        }
    }
    
    func begin() {
        timer = Timer.scheduledTimer(timeInterval: 0.75,
                                     target: self,
                                     selector: #selector(performMove),
                                     userInfo: nil, repeats: true)
    }
    
    func addMark(at position: GameboardPosition) {
        guard let gameboardView = gameboardView else { return }
        
        gameboard?.setPlayer(player, at: position)
        
        if !gameboardView.canPlaceMarkView(at: position) {
            gameboardView.removeMarkView(at: position)
        }
        
        gameboardView.placeMarkView(player.markViewPrototype.copy(), at: position)
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
