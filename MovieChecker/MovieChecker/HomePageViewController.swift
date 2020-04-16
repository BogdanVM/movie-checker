//
//  HomePageViewController.swift
//  MovieChecker
//
//  Created by user169883 on 4/13/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class HomePageViewController: UIViewController {
    
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = Auth.auth().currentUser
        
        guard let fullName = user?.displayName else { return
        }
        
//        let email = user?.email
        let photoUrl = user?.photoURL
       
        changeImage(photoUrl)
        setWelcomeMessage(fullName)
    }
    
    private func makeImageRound() {
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
    }
    
    private func changeImage(_ photoUrl: URL?) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: photoUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        }
        
        makeImageRound()
    }

    private func setWelcomeMessage(_ fullName: String) {
        self.userNameLbl.text! = fullName
    }

}
