//
//  MainMenuViewController.swift
//  XO-game
//
//  Created by Константин Шмондрик on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    @IBOutlet weak var twoPlayersButton: UIButton!
    @IBOutlet weak var computerButton: UIButton!
    @IBOutlet weak var fiveByFiveButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func twoPlayersButtonAction(_ sender: Any) {
        GameSession.shared.mode = .againstHuman
        performSegue(withIdentifier: "StartGame", sender: self)
        
    }
    
    @IBAction func computerButtonAction(_ sender: Any) {
        GameSession.shared.mode = .againstComputer
        performSegue(withIdentifier: "StartGame", sender: self)
        
    }
    
    @IBAction func fiveByFiveButtonAction(_ sender: Any) {
        GameSession.shared.mode = .fiveByFive
        performSegue(withIdentifier: "StartGame", sender: self)
        
    }
    
    
    
}
