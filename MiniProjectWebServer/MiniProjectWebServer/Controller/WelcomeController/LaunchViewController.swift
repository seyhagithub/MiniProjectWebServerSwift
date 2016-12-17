//
//  LaunchViewController.swift
//  MiniProjectWebServer
//
//  Created by Hiem Seyha on 12/17/16.
//  Copyright © 2016 seyha. All rights reserved.
//

import UIKit
import PKHUD
class LaunchViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        HUD.show(.progress)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
            HUD.hide()
    }
}
