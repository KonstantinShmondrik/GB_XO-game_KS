//
//  LogCommand.swift
//  XO-game
//
//  Created by Константин Шмондрик on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

// MARK: - Command

final class LogCommand {
    
    let action: LogAction
    
    init(action: LogAction) {
        self.action = action
    }
    
    var logMessage: String {
        switch self.action {
       
        case .playerInput(let player, let position):
            return "\(player) placed mark at \(position)"
        
        case .gameFinished(let winner):
            if let winner = winner {
                return "\(winner) win game"
            } else {
                return "game finished with no winner"
            }
       
        case .restartGame:
            return "game restarted"
        }
    }
}
