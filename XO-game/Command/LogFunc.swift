//
//  LogFunc.swift
//  XO-game
//
//  Created by Константин Шмондрик on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

public func Log(_ action: LogAction) {
    
    let command = LogCommand(action: action)
    LoggerInvoker.shared.addLogCommand(command)
    
}
