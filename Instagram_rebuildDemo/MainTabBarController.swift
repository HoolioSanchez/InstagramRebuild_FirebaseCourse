//
//  MainTabBarController.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 5/22/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if Auth.auth().currentUser == nil {
            
            //show if not logged in
            DispatchQueue.main.async {
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }

            print("present setupViewController")
            return
        }
        
        setupViewControllers()
    }

    func setupViewControllers() {
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        self.viewControllers = [navController, UIViewController()]
    }
    
}
