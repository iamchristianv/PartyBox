//
//  UIFont+Extension.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

extension UIFont {

    struct Partybox {
    
        static let avenirNextRegularName: String = "AvenirNext-Regular"

        static let avenirNextMediumName: String = "AvenirNext-Medium"

        static func avenirNextMedium(size: CGFloat) -> UIFont {
            return UIFont(name: UIFont.Partybox.avenirNextMediumName, size: size)!
        }

        static func avenirNextRegular(size: CGFloat) -> UIFont {
            return UIFont(name: UIFont.Partybox.avenirNextRegularName, size: size)!
        }
    }
    
}
