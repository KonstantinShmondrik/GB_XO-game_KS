//
//  LogAction.swift
//  XO-game
//
//  Created by Константин Шмондрик on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public enum LogAction {
    
    case playerInput(player: Player, position: GameboardPosition)
    case gameFinished(winner: Player?)
    case restartGame

}

