//
//  CircleView.swift
//  Partybox
//
//  Created by Christian Villa on 1/15/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class CircleView: ShapeView {

    // MARK: - Draw Functions
    
    override func draw(_ rect: CGRect) {
        let pathX = self.frame.size.width / 2 - self.frame.size.height / 2

        self.path = UIBezierPath(ovalIn: CGRect(x: pathX, y: 0.0, width: self.frame.size.width, height: self.frame.size.height))
        
        self.color.setFill()
        self.path.fill()
        
        self.path.close()
    }

}
