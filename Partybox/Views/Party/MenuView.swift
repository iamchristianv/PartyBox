//
//  MenuView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class MenuView: BaseView {

    // MARK: - Instance Properties
    
    lazy var startPartyButton: UIButton = {
        let startPartyButton = UIButton()
        startPartyButton.setTitle("Start a Party", for: .normal)
        startPartyButton.setTitleColor(.black, for: .normal)
        startPartyButton.setTitleFont(UIFont.avenirNextRegularName, size: 24)
        return startPartyButton
    }()
    
    lazy var joinPartyButton: UIButton = {
        let joinPartyButton = UIButton()
        joinPartyButton.setTitle("Join a Party", for: .normal)
        joinPartyButton.setTitleColor(.black, for: .normal)
        joinPartyButton.setTitleFont(UIFont.avenirNextRegularName, size: 24)
        return joinPartyButton
    }()
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.startPartyButton)
        self.addSubview(self.joinPartyButton)
        
        self.startPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.center.equalTo(self.snp.center)
        })
        
        self.joinPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.startPartyButton.snp.bottom).offset(64)
        })
    }

}
