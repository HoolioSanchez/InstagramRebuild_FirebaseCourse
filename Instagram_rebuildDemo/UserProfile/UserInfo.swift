//
//  User.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 6/2/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.
//

import Foundation

struct UserInfo {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["fileImageUrl"] as? String ?? ""
    }
}// end of user
