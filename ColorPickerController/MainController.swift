//
//  MainController.swift
//  ColorPopOver
//
//  Created by Gazolla on 03/08/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    lazy var btn:ColorButton = {
        let btn = ColorButton(type: UIButtonType.custom)
        btn.setTitle("select a color", for: .normal)
        btn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func btnTapped(){
        let colorPickerController = ColorPickerController()
        colorPickerController.modalPresentationStyle = .overCurrentContext
        colorPickerController.selectedColor = { color in
            self.view.backgroundColor = color
            self.btn.squareColor = color
        }
        present(colorPickerController, animated: true){
            colorPickerController.addBlur()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(btn)
        
        btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        btn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
}
