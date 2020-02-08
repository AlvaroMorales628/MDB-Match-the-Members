//
//  ViewController.swift
//  MDB Member Match
//
//  Created by Geovanni Morales on 2/5/20.
//  Copyright © 2020 Geovanni Morales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Everything done on the main page is on the storyboard, no programmed features
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }


}

