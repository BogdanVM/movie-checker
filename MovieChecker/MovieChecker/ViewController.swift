//
//  ViewController.swift
//  MovieChecker
//
//  Created by user169883 on 4/12/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if user?.uid != nil {
            redirectSignedUser()
        }
    }

    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Login Successful.")
                    self.redirectSignedUser()
                }
            }
    }
    
    private func redirectSignedUser() {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainTabBarController = mainStoryboard.instantiateViewController(withIdentifier: "mainTabBarController") as? MainTabBarController else {
            return
        }
        
        present(mainTabBarController, animated: true, completion: nil)
    }
}

