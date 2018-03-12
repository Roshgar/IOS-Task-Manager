//
//  ViewController.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var connectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        connectButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func connect(_ sender: Any) {
        performSegue(withIdentifier: "showHome", sender: nil)
    }
    
}

