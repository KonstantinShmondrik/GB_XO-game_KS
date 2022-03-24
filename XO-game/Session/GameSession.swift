//
//  GameSession.swift
//  XO-game
//
//  Created by Константин Шмондрик on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class GameSession {
    
    static let shared = GameSession()
    private init() {}
    
    var mode: GameMode?
    
//    var playerFirstMoves: [PlayerMove] = []
//    var playerSecondMoves: [PlayerMove] = []
}
