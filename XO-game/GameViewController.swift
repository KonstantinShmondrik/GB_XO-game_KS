//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
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
        
        self.configureUI()
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.counter += 1
                self.goToNextState()
                print(self.counter)
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        gameboard.clear()
        gameboardView.clear()
        counter = 0
        goToFirstState()
        
        
    }
    
    private func goToFirstState() {
        let player = Player.first
        self.currentState = PlayerInputState(player: player,
                                             markViewPrototype: player.markViewPrototype,
                                             gameViewController: self,
                                             gameboard: gameboard,
                                             gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        
        
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        if counter >= (GameboardSize.columns * GameboardSize.rows) {
            self.currentState = GameEndedState(winner: nil, gameViewController: self)
            return
        }
        
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            
            if player == .first || player == .second {
                self.currentState = PlayerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
            } else {
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
        }
        
    }
    
    private func configureUI() {
        if mode == .againstComputer {
            firstPlayerTurnLabel.text = "Human"
            secondPlayerTurnLabel.text = "Computer"
        }
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
}

