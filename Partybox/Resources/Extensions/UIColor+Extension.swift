//
//  UIColor+Extension.swift
//  Partybox
//
//  Created by Christian Villa on 1/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct Partybox {
        
        static var white: UIColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        static var red: UIColor = UIColor(red: 235.0/255.0, green: 40.0/255.0, blue: 85.0/255.0, alpha: 1.0)
        
        static var blue: UIColor = UIColor(red: 60.0/255.0, green: 180.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        
        static var purple: UIColor = UIColor(red: 155.0/255.0, green: 85.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        
        static var green: UIColor = UIColor(red: 30.0/255.0, green: 190.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        
        static var black: UIColor = UIColor(red: 70.0/255.0, green: 75.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        
        static var lightGray: UIColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        static var darkGray: UIColor = UIColor.darkGray
        
    }
    
    func contrastColor() -> UIColor {
        var redValue = 0.0 as CGFloat
        var greenValue = 0.0 as CGFloat
        var blueValue = 0.0 as CGFloat
        
        self.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: nil)
        
        redValue *= 255.0
        greenValue *= 255.0
        blueValue *= 255.0
        
        let colorThreshold = 100.0 as CGFloat
        let colorDelta = (redValue * 0.299) + (greenValue * 0.587) + (blueValue * 0.114)
        
        let contrastColor = colorDelta > colorThreshold ? UIColor.Partybox.white : UIColor.Partybox.black
        
        return contrastColor
    }
    
}
