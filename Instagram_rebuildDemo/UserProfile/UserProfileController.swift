//
//  UserProfileController.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 5/22/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: UserInfo?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white

        self.navigationItem.title = Auth.auth().currentUser?.uid
        
        fetchUser()

        navigationItem.title = "User Profile"
        
        //need to register the collect
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
    
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogOutButton()
    
    }
    
    fileprivate func setupLogOutButton(){
        
        let icon = #imageLiteral(resourceName: "gearxy").withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    @objc func handleLogOut(){
        print("EVENT LOG: USER LOG OUT")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                
                try Auth.auth().signOut()
                
                //what happens? we need to present some kind of login controller
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .green
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
        
    }
    
    fileprivate func fetchUser(){
    
    guard let userId = Auth.auth().currentUser?.uid else { return }
    
    Database.database().reference().child("user").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
        
        print(snapshot.value ?? "NONE")
        
        // 'snapshot.value' is of type 'Any' so we are casting it as a dictionary so we can access it as string.
        guard let dictionary = snapshot.value as? [String: Any] else { return }
        
        // accessing username as a string
        let profileImageUrl = dictionary["fileImageUrl"] as? String
        print("EVENT LOG: User profileImage Url \(profileImageUrl ?? "failed to grab url")")
        
        let username = dictionary["username"] as? String
        print("EVENT LOG: User username Url \(username ?? "failed to print username")" )


        //Setting user dictionary to User
        self.user = UserInfo(dictionary: dictionary)
        
        //Setting title
        self.navigationItem.title = self.user?.username
        
        //
        self.collectionView?.reloadData()

    }) { (err) in
        print("EVENT LOG: Failed to fetch user id -", err)
        }
    
    }
}
