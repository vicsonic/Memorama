//
//  PrizeViewController.swift
//  Memorama
//
//  Created by Victor Soto on 10/24/17.
//  Copyright © 2017 Radial Loop Inc. All rights reserved.
//

import UIKit

class PrizeViewController: UIViewController {
    
    enum Mode : String {
        case Sneakers
        case Textile
    }
    
    var mode: Mode = .Textile
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: mode.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
