//
//  ColorList.swift
//  ColorPopOver
//
//  Created by Gazolla on 03/08/17.
//  Copyright © 2017 Gazolla. All rights reserved.
//

import UIKit

class ColorPickerController: UIViewController {
    
    var selectedColor:((_ color:UIColor)->())?
    
    var color:UIColor? {
        didSet{
            self.selectedColor?(color!)
        }
    }
    
    lazy var colorCollection:ColorCollection = {
        let cc = ColorCollection()
        cc.layer.cornerRadius = 5
        cc.translatesAutoresizingMaskIntoConstraints = false
        cc.dismiss = {
            self.removeBlurAndDismiss()
        }
        cc.selectedColor = { color in
            self.color = color
        }
        return cc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(blur)
        self.view.addSubview(colorCollection)
        self.view.backgroundColor = .clear
        
        colorCollection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        colorCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        colorCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.55).isActive = true
        colorCollection.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.38).isActive = true
    }
    
    lazy var blur:UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    func addBlur(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        UIView.animate(withDuration: 0.5) {
            self.blur.effect = blurEffect
        }
    }
    
    func removeBlurAndDismiss(){
        UIView.animate(withDuration: 0.4, animations: {
            self.blur.effect = nil
        }) { (Bool) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

class ColorCollection: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var dismiss:(()->())?
    var selectedColor:((_ color:UIColor)->())?
    
    lazy var navBar:UINavigationBar = {
        let nb: UINavigationBar = UINavigationBar()
        nb.translatesAutoresizingMaskIntoConstraints = false
        let navItem = UINavigationItem()
        nb.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AlNile", size: 14)!,
                                  NSForegroundColorAttributeName:UIColor.black]
        navItem.title = "Select a color:"
        let btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(btnDismiss))
        navItem.leftBarButtonItem = btn
        nb.pushItem(navItem, animated: true)
        nb.layer.cornerRadius = 5
        return nb
    }()
    
    lazy var collectionView:UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.itemSize = CGSize(width: 48, height: 48)
        l.minimumInteritemSpacing = 1.0
        l.minimumLineSpacing = 2.0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: l)
        cv.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        cv.layer.cornerRadius = 5
        cv.alwaysBounceVertical = true
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var stack:UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.distribution = .fill
        s.alignment = .center
        s.spacing   = 2.0
        s.translatesAutoresizingMaskIntoConstraints = false
        s.addArrangedSubview(self.navBar)
        s.addArrangedSubview(self.collectionView)
        return s
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        stack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        navBar.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        
        collectionView.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        collectionView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.83).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var colorList:[UIColor] = {
        let color = UIColor()
        return color.allColors()
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let item = colorList[indexPath.item]
        cell.layer.cornerRadius = 3.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = colorList[indexPath.item]
        selectedColor?(item)
        dismiss?()
    }
    
    func btnDismiss(){
        dismiss?()
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension UIColor {
    struct FlatColor {
        struct Pink {
            static let Pink = UIColor(hex: "0xFFC0CB")
            static let LightPink = UIColor(hex: "0xFFB6C1")
            static let HotPink = UIColor(hex: "0xFF69B4")
            static let DeepPink = UIColor(hex: "0xFF1493")
        }
        
        struct Red {
            static let IndianRed = UIColor(hex: "0xCD5C5C")
            static let Crimson = UIColor(hex: "0xDC143C")
            static let FireBrick = UIColor(hex: "0xB22222")
            static let DarkRed = UIColor(hex: "0x8B0000")
        }
        
        struct Orange {
            static let Tomato = UIColor(hex: "0xFF6347")
            static let Coral = UIColor(hex: "0xFF7F50")
            static let DarkOrange = UIColor(hex: "0xFF8C00")
            static let Orange = UIColor(hex: "0xFFA500")
        }
        
        struct Yellow {
            static let PaleGoldenrod = UIColor(hex: "0xEEE8AA")
            static let Khaki = UIColor(hex: "0xF0E68C")
            static let DarkKhaki = UIColor(hex: "0xBDB76B")
            static let Gold = UIColor(hex: "0xFFD700")
        }
        
        struct Brown {
            static let SandyBrown = UIColor(hex: "0xF4A460")
            static let SaddleBrown = UIColor(hex: "0x8B4513")
            static let Sienna = UIColor(hex: "0xA0522D")
            static let Brown = UIColor(hex: "0xA52A2A")
            static let Maroon = UIColor(hex: "0x800000")
        }
        
        struct Green {
            static let Lime = UIColor(hex: "0x00FF00")
            static let SpringGreen = UIColor(hex: "0x00FF7F")
            static let SeaGreen = UIColor(hex: "0x2E8B57")
            static let DarkGreen = UIColor(hex: "0x006400")
        }
        
        struct Blue {
            static let SkyBlue = UIColor(hex: "0x87CEEB")
            static let DodgerBlue = UIColor(hex: "0x1E90FF")
            static let SteelBlue = UIColor(hex: "0x4682B4")
            static let Navy = UIColor(hex: "0x000080")
        }
        
        struct Gray {
            static let AlmondFrost = UIColor(hex: "0xA28F85")
            static let WhiteSmoke = UIColor(hex: "0xEFEFEF")
            static let Iron = UIColor(hex: "0xD1D5D8")
            static let IronGray = UIColor(hex: "0x75706B")
        }
    }
}

extension UIColor {
    func allColors()->[UIColor] {
        return [UIColor.clear,
                UIColor.white,
                UIColor.black,
                UIColor.FlatColor.Gray.WhiteSmoke,
                UIColor.FlatColor.Gray.Iron,
                UIColor.FlatColor.Gray.AlmondFrost,
                UIColor.FlatColor.Gray.IronGray,
                UIColor.FlatColor.Blue.SkyBlue,
                UIColor.FlatColor.Blue.DodgerBlue,
                UIColor.FlatColor.Blue.SteelBlue,
                UIColor.FlatColor.Blue.Navy,
                UIColor.FlatColor.Green.Lime,
                UIColor.FlatColor.Green.SpringGreen,
                UIColor.FlatColor.Green.SeaGreen,
                UIColor.FlatColor.Green.DarkGreen,
                UIColor.FlatColor.Brown.SaddleBrown,
                UIColor.FlatColor.Brown.Sienna,
                UIColor.FlatColor.Brown.Brown,
                UIColor.FlatColor.Brown.Maroon,
                UIColor.FlatColor.Yellow.PaleGoldenrod,
                UIColor.FlatColor.Yellow.Khaki,
                UIColor.FlatColor.Yellow.DarkKhaki,
                UIColor.FlatColor.Yellow.Gold,
                UIColor.FlatColor.Orange.Tomato,
                UIColor.FlatColor.Orange.Coral,
                UIColor.FlatColor.Orange.DarkOrange,
                UIColor.FlatColor.Orange.Orange,
                UIColor.FlatColor.Red.IndianRed,
                UIColor.FlatColor.Red.Crimson,
                UIColor.FlatColor.Red.FireBrick,
                UIColor.FlatColor.Red.DarkRed,
                UIColor.FlatColor.Pink.Pink,
                UIColor.FlatColor.Pink.LightPink,
                UIColor.FlatColor.Pink.HotPink,
                UIColor.FlatColor.Pink.DeepPink
        ]
    }
}

