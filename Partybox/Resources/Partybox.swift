//
//  Partybox.swift
//  Partybox
//
//  Created by Christian Villa on 5/16/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

struct Partybox {

    struct values {

        // MARK: - Default Values

        static let none: String = "none"

        static let null: NSNull = NSNull()

        static let zero: Int = 0

        static func randomPartyId() -> String {
            var randomId = ""

            let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                           "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

            let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

            for _ in 1...5 {
                let randomIndex = Int(arc4random())
                let randomLetter = letters[randomIndex % letters.count]
                let randomNumber = String(numbers[randomIndex % numbers.count])

                randomId += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
            }

            return randomId
        }

        static func randomPersonEmoji() -> String {
            let emojis = ["😊"]

            let randomIndex = Int(arc4random()) % emojis.count
            let randomEmoji = emojis[randomIndex]

            return randomEmoji
        }

        static func randomGameId() -> String {
            let randomId = "C2D4V"

            return randomId
        }

    }

    struct colors {

        // MARK: - Color Values

        static var white: UIColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        static var red: UIColor = UIColor(red: 235.0/255.0, green: 40.0/255.0, blue: 85.0/255.0, alpha: 1.0)

        static var blue: UIColor = UIColor(red: 60.0/255.0, green: 180.0/255.0, blue: 225.0/255.0, alpha: 1.0)

        static var purple: UIColor = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 160.0/255.0, alpha: 1.0)

        static var green: UIColor = UIColor(red: 30.0/255.0, green: 190.0/255.0, blue: 155.0/255.0, alpha: 1.0)

        static var black: UIColor = UIColor(red: 70.0/255.0, green: 75.0/255.0, blue: 80.0/255.0, alpha: 1.0)

        static var lightGray: UIColor = UIColor.lightGray.withAlphaComponent(0.5)

        static var darkGray: UIColor = UIColor.darkGray

    }

    struct fonts {

        // MARK: - Font Values

        static let avenirNextRegularName: String = "AvenirNext-Regular"

        static let avenirNextMediumName: String = "AvenirNext-Medium"

        static func avenirNextRegular(size: CGFloat) -> UIFont {
            return UIFont(name: Partybox.fonts.avenirNextRegularName, size: size)!
        }

        static func avenirNextMedium(size: CGFloat) -> UIFont {
            return UIFont(name: Partybox.fonts.avenirNextMediumName, size: size)!
        }

    }

}
