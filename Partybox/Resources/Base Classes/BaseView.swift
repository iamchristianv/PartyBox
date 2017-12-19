//
//  BaseView.swift
//  Partybox
//
//  Created by Christian Villa on 11/26/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
