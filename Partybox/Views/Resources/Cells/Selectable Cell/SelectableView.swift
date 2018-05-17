//
//  SelectableView.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SelectableView: UIView {

    // MARK: - Instance Properties
    
    private lazy var outerView: CircleView = {
        let outerView = CircleView(frame: .zero, color: Partybox.colors.lightGray)
        return outerView
    }()
    
    private lazy var innerView: CircleView = {
        let innerView = CircleView(frame: .zero, color: Partybox.colors.white)
        return innerView
    }()

    // MARK: - Construction Functions

    static func construct() -> SelectableView {
        let view = SelectableView()
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
        self.addSubview(self.outerView)
        self.addSubview(self.innerView)
        
        self.outerView.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
            make.center.equalTo(self.snp.center)
        })
        
        self.innerView.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(self.outerView.snp.width).offset(-2)
            make.height.equalTo(self.outerView.snp.height).offset(-2)
            make.center.equalTo(self.outerView.snp.center)
        })
    }
    
    // MARK: - Setter Functions
    
    func setSelected(_ selected: Bool) {
        self.innerView.color = selected ? Partybox.colors.green : Partybox.colors.white
        self.innerView.setNeedsDisplay()
    }
    
}
