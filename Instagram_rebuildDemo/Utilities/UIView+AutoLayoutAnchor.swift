//
//  UIView+AutoLayoutAnchor.swift
//  Instagram_rebuildDemo
//
//  Created by Julio Rodriquez on 5/7/18.
//  Copyright © 2018 Julio Sanchez. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
}
