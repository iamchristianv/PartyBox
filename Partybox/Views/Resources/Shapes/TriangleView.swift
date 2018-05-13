//
//  Triangle.swift
//  Partybox
//
//  Created by Christian Villa on 1/15/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class TriangleView: ShapeView {
    
    // MARK: - Draw Functions
    
    override func draw(_ rect: CGRect) {
        self.path = UIBezierPath()
        
        self.path.move(to: CGPoint(x: self.frame.width / 2, y: 0.0))
        self.path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        self.path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        self.color.setFill()
        self.path.fill()
        
        self.path.close()
    }

}
