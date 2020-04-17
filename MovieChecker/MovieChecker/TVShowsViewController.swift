//
//  TVShowsViewController.swift
//  MovieChecker
//
//  Created by user169883 on 4/17/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class TVShowsViewController: UIViewController {

    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clcik(_ sender: UIButton) {
    }
}
