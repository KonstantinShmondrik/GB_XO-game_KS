//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var gameboardView: GameboardView!
    
    
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    let mode = GameSession.shared.mode
    private var counter = 0
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            
            self.currentState.addMark(at: position)
            
            if self.currentState.isCompleted {
                if self.mode == .fiveByFive {
                    self.delay(0.5) {
                        self.gameboardView.clear()
                        self.gameboard.clear()
                        self.goToNextState()
                    }
                } else {
                    self.counter += 1
                    self.goToNextState()
                }
            }
        }
        
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        gameboard.clear()
        gameboardView.clear()
        counter = 0
        GameSession.shared.playerFirstMoves = []
        GameSession.shared.playerSecondMoves = []
        goToFirstState()
    }
    
    // MARK: - First State
    private func goToFirstState() {
        let player = Player.first
        
        if mode == .fiveByFive {
            currentState = FiveByFiveState(player: player,
                                           markViewPrototype: player.markViewPrototype,
                                           gameViewController: self,
                                           gameboard: gameboard,
                                           gameboardView: gameboardView)
        } else {
            self.currentState = PlayerInputState(player: player,
                                                 markViewPrototype: player.markViewPrototype,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView)
        }
    }
    
    // MARK: - Nex State
    private func goToNextState() {
        // Проверяем есть ли совпадения выигрышных комбинаций
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        // Проверяем заполнено ли все поле (победителя нет)
        if counter >= (GameboardSize.columns * GameboardSize.rows) {
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }
        // Проверяем наполнение обоих массивов ходов игроков при игре на пять ходов
        if mode == .fiveByFive && checkForGameCompleted() {
            endedStateToFiveByFive()
        }
        // Поочередные ходы игроков в зависимости от режимов игры (2 игрока или с компьютером)
        if mode == .fiveByFive, let playerInputState = currentState as? FiveByFiveState {
            let player = playerInputState.player.next
            currentState = FiveByFiveState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
            
        } else if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            
            if player == .first || player == .second {
                self.currentState = PlayerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
            } else {
                goToComputerState()
            }
        }
    }
    
    // MARK: - Computer State
    private func goToComputerState() {
        let player = Player.computer
        delay(0.5) { [self] in
            currentState = ComputerInputState(player: player,
                                              markViewPrototype: player.markViewPrototype,
                                              gameViewController: self,
                                              gameboard: gameboard,
                                              gameboardView: gameboardView)
            
            if let winner = self.referee.determineWinner() {
                self.currentState = GameEndedState(winner: winner, gameViewController: self)
                return
            } else {
                counter += 1
                goToFirstState()
            }
        }
    }
    // MARK: - Окончание игры в режиме FiveByFive
    private func endedStateToFiveByFive() {
        
        currentState = GameExecuteState(gameViewController: self,
                                        gameboard: gameboard,
                                        gameboardView: gameboardView) { [self] in
            
            if let winner = referee.determineWinner() {
                Log(.gameFinished(winner: winner))
                
                currentState = GameEndedState(winner: winner, gameViewController: self)
            } else {
                Log(.gameFinished(winner: nil))
                currentState = GameEndedState(winner: nil, gameViewController: self)
            }
        }
        return
        
    }
    
    private func checkForGameCompleted() -> Bool {
        return GameSession.shared.playerFirstMoves.count > 0 && GameSession.shared.playerSecondMoves.count > 0
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

