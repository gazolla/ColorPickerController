//
//  ColorButton.swift
//  ColorPopOver
//
//  Created by Gazolla on 04/08/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

class ColorButton: UIButton {
    
    var squareColor:UIColor? {
        didSet{
            self.squareView.backgroundColor = squareColor!
        }
    }
    
    var squareView:UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setTitleColor(.black, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 4
        self.addSubview(squareView)
        
        let margins = self.layoutMarginsGuide
        
        squareView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        squareView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        squareView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        squareView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
    }
}
