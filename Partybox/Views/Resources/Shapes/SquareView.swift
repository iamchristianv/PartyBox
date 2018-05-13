//
//  SquareView.swift
//  Partybox
//
//  Created by Christian Villa on 1/15/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SquareView: ShapeView {
    
    // MARK: - Draw Functions
    
    override func draw(_ rect: CGRect) {
        self.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 2.0)

        self.color.setFill()
        self.path.fill()
        
        self.path.close()
    }

}
