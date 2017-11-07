//
//  Font.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class Font {
    
    // MARK: - Font Methods
    
    static let avenirNextRegularName: String = "AvenirNext-Regular"
    
    static func avenirNextRegular(size: CGFloat) -> UIFont {
        return UIFont(name: avenirNextRegularName, size: size)!
    }
    
}
