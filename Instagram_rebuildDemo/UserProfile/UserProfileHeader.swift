//
//  UserProfileHeader.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 6/2/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: UserInfo? {
        didSet {
            setupProfileImage()
            
            usernameLabel.text = self.user?.username
        }
    }
    
    let profileImageView: UIImageView = {
         let iv = UIImageView()
        return iv
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Posts", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                                                               NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Followers", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                                                               NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label

    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Following", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                                                               NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, right: nil, paddingRight: 0, left: leftAnchor, paddingLeft: 12, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 4, bottom: gridButton.topAnchor, paddingBottom: 0, right: rightAnchor, paddingRight: -12, left: leftAnchor, paddingLeft: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postLabel.bottomAnchor, paddingTop: 8, bottom: nil, paddingBottom: 0, right: followingLabel.rightAnchor, paddingRight: -20, left: postLabel.leftAnchor, paddingLeft: 0, width: 0, height: 34)
    }
    
    fileprivate func setupUserStatsView(){
        
        let stackView = UIStackView(arrangedSubviews: [postLabel,followersLabel,followingLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, right: rightAnchor, paddingRight: 12, left: profileImageView.rightAnchor, paddingLeft: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolbar(){
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDivderView = UIView()
        bottomDivderView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDivderView)
        
        stackView.anchor(top: nil, paddingTop: 0, bottom: self.bottomAnchor, paddingBottom: 0, right: rightAnchor, paddingRight: 0, left: leftAnchor, paddingLeft: 0, width: 0, height: 50)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        topDividerView.anchor(top: stackView.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, right: stackView.rightAnchor, paddingRight: 0, left: stackView.leftAnchor, paddingLeft: 0, width: 0, height: 0.5)
        
        bottomDivderView.anchor(top: nil, paddingTop: 0, bottom: stackView.bottomAnchor, paddingBottom: 0, right: stackView.rightAnchor, paddingRight: 0, left: stackView.leftAnchor, paddingLeft: 0, width: 0, height: 0.5)
        
        
    }
    
    fileprivate func setupProfileImage() {

        guard let userImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: userImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Checking for errors
            if let err = error {
                print("EVENT LOG: Failed to fetch profile image -", err)
                return
            }
            
            //Checking Severs Response status
            if let httpRes = response as? HTTPURLResponse {
                if httpRes.statusCode != 200{
                    print("EVENT Log: Sever issue - ",httpRes.statusCode)
                } else {
                    
                    guard let data = data else { return }
                    
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
            
        }.resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
