//
//  UIFont+Extension.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

extension UIFont {
    
    static let avenirNextRegularName: String = "AvenirNext-Regular"
    
    static let avenirNextMediumName: String = "AvenirNext-Medium"
    
    static func avenirNextMedium(size: CGFloat) -> UIFont {
        return UIFont(name: UIFont.avenirNextMediumName, size: size)!
    }
    
    static func avenirNextRegular(size: CGFloat) -> UIFont {
        return UIFont(name: UIFont.avenirNextRegularName, size: size)!
    }
    
}
