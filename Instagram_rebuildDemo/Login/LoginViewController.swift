//
//  LoginViewController.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 6/7/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
       view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        let logoImage = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImage.contentMode = .scaleAspectFit
        
        view.addSubview(logoImage)
        
        logoImage.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, right: nil, paddingRight: 0, left: nil, paddingLeft: 0, width: 200, height: 50)
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray] )
        
        attributedText.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedText, for: .normal)
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let emailTextFieldLabel: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        
        return tf
    }()
    
    let passwordTextFieldLabel: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInput), for: .editingChanged)
        
        return tf
    }()
    
    let loginButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    @objc func handleLogin() {
        
        guard let email = emailTextFieldLabel.text else { return }
        guard let password = passwordTextFieldLabel.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Failed to login: ", err)
                return
            }
            
            print("Successfully logged the user in: ", user?.uid ?? " ")
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
   @objc func handleShowSignUp() {
    let signUpVC = SignUpViewController()
    
    navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true

        view.addSubview(signUpButton)
        view.addSubview(logoContainerView)
        
        logoContainerView.anchor(top: view.topAnchor, paddingTop: 0, bottom: nil, paddingBottom: 0, right: view.rightAnchor, paddingRight: 0, left: view.leftAnchor, paddingLeft: 0, width: 0, height: 150)
        
        signUpButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, right: view.rightAnchor, paddingRight: 0, left: view.leftAnchor, paddingLeft: 0, width: 0, height: 50)
        
        setupInputField()
        
    }
    
    @objc func handleTextInput() {
        
        let isValidForm = emailTextFieldLabel.text?.count ?? 0 > 0 && passwordTextFieldLabel.text?.count ?? 0 > 0
        
        if isValidForm {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red: 17/225, green: 154/255, blue: 237/255, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
    }
    
    
    fileprivate func setupInputField() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextFieldLabel,passwordTextFieldLabel,loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
    
        view.addSubview(stackView)
        
        stackView.anchor(top: logoContainerView.bottomAnchor, paddingTop: 40, bottom: nil, paddingBottom: 0, right: view.rightAnchor, paddingRight: -40, left: view.leftAnchor, paddingLeft: 40, width: 0, height: 140)
    }
    
}
