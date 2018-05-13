//
//  UIButton+Extension.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

extension UIButton {

    // MARK: - Button Extension Functions
    
    func setTitleFont(_ name: String, size: CGFloat) {
        self.titleLabel?.font = UIFont(name: name, size: size)
    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
}
