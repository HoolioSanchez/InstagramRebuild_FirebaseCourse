//
//  SignUpViewController.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 5/6/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let addPhotoButton: UIButton = {
        
        let buttton = UIButton()
        buttton.translatesAutoresizingMaskIntoConstraints = false
        buttton.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        buttton.addTarget(self, action: #selector(saveAvatar), for: .touchUpInside)
        
        return buttton
    }()
    
    @objc func saveAvatar() {
        print("12234")
        let imagePickerController = UIImagePickerController()
        present(imagePickerController, animated: true, completion: nil)
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addPhotoButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
    }
    
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
    
    let usernameTextFieldLabel: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Username"
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
    
    let signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    let alreadyHaveAnAccountButton: UIButton = {
    let button = UIButton(type: .system)
    
    let attributedText = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray] )
    
    attributedText.append(NSAttributedString(string: "Sign in", attributes: [NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
    
    button.setAttributedTitle(attributedText, for: .normal)
    
    button.addTarget(self, action: #selector(handleLoginVC), for: .touchUpInside)
    return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(alreadyHaveAnAccountButton)
        
        alreadyHaveAnAccountButton.anchor(top: nil, paddingTop: 0, bottom: view.bottomAnchor, paddingBottom: 0, right: view.rightAnchor, paddingRight: 0, left: view.leftAnchor, paddingLeft: 0, width: 0, height: 50)
        addPhotoAutoLayout()
        textFieldStackView()

    }
    
    @objc func handleLoginVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInput() {
        
        let isValidForm = emailTextFieldLabel.text?.count ?? 0 > 0 && usernameTextFieldLabel.text?.count ?? 0 > 0 && passwordTextFieldLabel.text?.count ?? 0 > 0
        
        if isValidForm {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red: 17/225, green: 154/255, blue: 237/255, alpha: 1)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
    }
    
    @objc func handleSignup() {
        print("EVENT LOG: signup button clicked")
        guard let email = emailTextFieldLabel.text, email.count > 0 else { return }
        guard let username = usernameTextFieldLabel.text, username.count > 0 else { return }
        guard let password = passwordTextFieldLabel.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            
            if let  err = error {
                print("EVENT LOG:There was an error, ", err)
            }
            print("EVENT LOG: Successful, user created uid-", user?.uid ?? "")
            
            guard let image = self.addPhotoButton.imageView?.image else { return }
            guard let uploadImage = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let storageRef = Storage.storage().reference()
            
            let filename = NSUUID().uuidString
            let storageRefChild = storageRef.child("profile_images").child(filename)
            
            storageRefChild.putData(uploadImage, metadata: nil, completion: { (metadata, error) in
                
                if let err = error {
                    print("EVENT LOG: error in uploading the image,", err)
                }
                
                storageRefChild.downloadURL(completion: { (url, error) in
                    if let err = error{
                        print("EVENT LOG: error in downloadurl, ", err)
                    }
                    
                    guard let profilePicUrl = url?.absoluteString else { return }
                    print("EVENT LOG: Profile Image Successfully uploaded", profilePicUrl)
                    
                    guard let uid = user?.uid else {return}
                    
                    let DictionaryValues = ["username": username, "fileImageUrl": profilePicUrl]
                    
                    let values = [uid: DictionaryValues]
                    
                    Database.database().reference().child("user").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                        if let err = err {
                        print("EVENT LOG: failed to save user info into db,", err)
                        }
                        print("EVENT LOG: Succesfully entered new user")
                    
                        })
                })
                
            })
            
            
        }
        
        //presenting the
        present(MainTabBarController(), animated: true, completion: nil)
        
    }

    fileprivate func addPhotoAutoLayout(){
        
        view.addSubview(addPhotoButton)
        
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        addPhotoButton.anchor(top: view.topAnchor, paddingTop: 100, bottom: nil, paddingBottom: 0, right: nil, paddingRight: 0, left: nil, paddingLeft: 0, width: 140, height: 140)
        
    }
    
    fileprivate func textFieldStackView() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextFieldLabel,usernameTextFieldLabel,passwordTextFieldLabel,signUpButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
    
        stackView.backgroundColor = .green
        
        self.view.addSubview(stackView)

        stackView.anchor(top: addPhotoButton.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, right: view.rightAnchor, paddingRight: -50, left: view.leftAnchor, paddingLeft: 50, width: 0, height: 200)
    }
    
}


