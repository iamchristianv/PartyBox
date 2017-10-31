//
//  StartPartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyView: UIView {

    // MARK: - Instance Properties
    
    var partyNameLabel: UILabel = {
        let partyNameLabel = UILabel()
        partyNameLabel.text = "Party Name"
        partyNameLabel.textColor = .black
        partyNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 24)
        return partyNameLabel
    }()
    
    var partyNameTextField: UITextField = {
        let partyNameTextField = UITextField()
        partyNameTextField.textColor = .black
        partyNameTextField.borderStyle = .roundedRect
        return partyNameTextField
    }()
    
    var yourNameLabel: UILabel = {
        let yourNameLabel = UILabel()
        yourNameLabel.text = "Your Name"
        yourNameLabel.textColor = .black
        yourNameLabel.font = UIFont(name: "AvenirNext-Regular", size: 24)
        return yourNameLabel
    }()
    
    var yourNameTextField: UITextField = {
        let yourNameTextField = UITextField()
        yourNameTextField.textColor = .black
        yourNameTextField.borderStyle = .roundedRect
        return yourNameTextField
    }()
    
    var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleFont("AvenirNext-Regular", size: 24)
        return startButton
    }()
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.partyNameLabel)
        self.partyNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(30)
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let navigationBarHeight = 44 as CGFloat
            make.top.equalTo(self.snp.top).offset(statusBarHeight + navigationBarHeight + 30)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.addSubview(self.partyNameTextField)
        self.partyNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.partyNameLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.addSubview(self.yourNameLabel)
        self.yourNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.partyNameTextField.snp.bottom).offset(64)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.addSubview(self.yourNameTextField)
        self.yourNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.yourNameLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.addSubview(self.startButton)
        self.startButton.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.yourNameTextField.snp.bottom).offset(64)
        })
    }

}
