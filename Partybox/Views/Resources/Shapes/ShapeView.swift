//
//  ShapeView.swift
//  Partybox
//
//  Created by Christian Villa on 1/15/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ShapeView: UIView {

    // MARK: - Instance Properties
    
    var path: UIBezierPath!
    
    var color: UIColor!
    
    // MARK: - Initialization Methods
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
