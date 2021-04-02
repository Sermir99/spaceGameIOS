//
//  ViewController.swift
//  spaceGame.v1
//
//  Created by Admin on 01.04.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func StartPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSpaceView", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
    }


}

