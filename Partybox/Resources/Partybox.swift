//
//  Partybox.swift
//  Partybox
//
//  Created by Christian Villa on 5/16/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import UIKit

enum PartyboxKey: String {

    case version

    case parties

    case store

}

struct Partybox {

    struct value {

        static let none: String = "none"

        static let null: NSNull = NSNull()

        static let zero: Int = 0

    }

    struct color {

        static var white: UIColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        static var red: UIColor = UIColor(red: 235.0/255.0, green: 40.0/255.0, blue: 85.0/255.0, alpha: 1.0)

        static var blue: UIColor = UIColor(red: 60.0/255.0, green: 180.0/255.0, blue: 225.0/255.0, alpha: 1.0)

        static var purple: UIColor = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 160.0/255.0, alpha: 1.0)

        static var green: UIColor = UIColor(red: 30.0/255.0, green: 190.0/255.0, blue: 155.0/255.0, alpha: 1.0)

        static var black: UIColor = UIColor(red: 70.0/255.0, green: 75.0/255.0, blue: 80.0/255.0, alpha: 1.0)

        static var lightGray: UIColor = UIColor.lightGray.withAlphaComponent(0.5)

        static var darkGray: UIColor = UIColor.darkGray

    }

    struct font {

        static let avenirNextRegularName: String = "AvenirNext-Regular"

        static let avenirNextMediumName: String = "AvenirNext-Medium"

        static func avenirNextRegular(size: CGFloat) -> UIFont {
            return UIFont(name: Partybox.font.avenirNextRegularName, size: size)!
        }

        static func avenirNextMedium(size: CGFloat) -> UIFont {
            return UIFont(name: Partybox.font.avenirNextMediumName, size: size)!
        }

    }

}
