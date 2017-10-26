//
//  PrizeViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

enum Prize : Int {
    case None
    case Textile
    case Sneakers
}

class PrizeViewController: UIViewController {
    
    var prize: Prize = .Textile
    
    @IBOutlet weak var prizeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = UIImage(named: "\(prize.rawValue)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func prizeButtonPressed(_ sender: Any) {
        showRegisterViewController()
    }
    
}
