//
//  MainTabBarController.swift
//  MovieChecker
//
//  Created by user169883 on 4/14/20.
//  Copyright © 2020 user169883. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeIndex(newIndex: Int) {
        self.selectedIndex = newIndex
    }

}
