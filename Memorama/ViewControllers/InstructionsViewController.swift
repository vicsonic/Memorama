//
//  InstructionsViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var instructionsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func instructionsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ShowGame", sender: self)
    }
    
}
