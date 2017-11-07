//
//  JoinPartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class JoinPartyView: UIView {

    // MARK: - Instance Properties
    
    var inviteCodeLabel: UILabel = {
        let inviteCodeLabel = UILabel()
        inviteCodeLabel.text = "Invite Code"
        inviteCodeLabel.textColor = .black
        inviteCodeLabel.font = Font.avenirNextRegular(size: 24)
        return inviteCodeLabel
    }()
    
    var inviteCodeTextField: UITextField = {
        let inviteCodeTextField = UITextField()
        inviteCodeTextField.textColor = .black
        inviteCodeTextField.borderStyle = .roundedRect
        return inviteCodeTextField
    }()
    
    var yourNameLabel: UILabel = {
        let yourNameLabel = UILabel()
        yourNameLabel.text = "Your Name"
        yourNameLabel.textColor = .black
        yourNameLabel.font = Font.avenirNextRegular(size: 24)
        return yourNameLabel
    }()
    
    var yourNameTextField: UITextField = {
        let yourNameTextField = UITextField()
        yourNameTextField.textColor = .black
        yourNameTextField.borderStyle = .roundedRect
        return yourNameTextField
    }()
    
    var joinButton: UIButton = {
        let joinButton = UIButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleColor(.black, for: .normal)
        joinButton.setTitleFont(Font.avenirNextRegularName, size: 24)
        return joinButton
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
        self.addSubview(self.inviteCodeLabel)
        self.addSubview(self.inviteCodeTextField)
        self.addSubview(self.yourNameLabel)
        self.addSubview(self.yourNameTextField)
        self.addSubview(self.joinButton)
        
        self.inviteCodeLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(30)
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let navigationBarHeight = 44 as CGFloat
            make.top.equalTo(self.snp.top).offset(statusBarHeight + navigationBarHeight + 30)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.inviteCodeTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.inviteCodeLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.yourNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.inviteCodeTextField.snp.bottom).offset(64)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.yourNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.yourNameLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-30)
        })
        
        self.joinButton.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.yourNameTextField.snp.bottom).offset(64)
        })
    }

}
