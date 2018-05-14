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
    
    lazy var outerView: CircleView = {
        let outerView = CircleView(frame: .zero, color: UIColor.Partybox.lightGray)
        return outerView
    }()
    
    lazy var innerView: CircleView = {
        let innerView = CircleView(frame: .zero, color: UIColor.Partybox.white)
        return innerView
    }()
    
    // MARK: - Initialization Functions
    
    init() {
        super.init(frame: .zero)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
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
        self.innerView.color = selected ? UIColor.Partybox.green : UIColor.Partybox.white
        self.innerView.setNeedsDisplay()
    }
    
}
