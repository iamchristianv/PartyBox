//
//  JoinPartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class JoinPartyView: BaseView {

    // MARK: - Instance Properties
    
    lazy var backgroundButton: UIButton = {
        let backgroundButton = UIButton()
        return backgroundButton
    }()
    
    lazy var inviteCodeLabel: UILabel = {
        let inviteCodeLabel = UILabel()
        inviteCodeLabel.text = "Invite Code"
        inviteCodeLabel.textColor = .black
        inviteCodeLabel.font = UIFont.avenirNextRegular(size: 24)
        return inviteCodeLabel
    }()
    
    lazy var inviteCodeTextField: UITextField = {
        let inviteCodeTextField = UITextField()
        inviteCodeTextField.textColor = .black
        inviteCodeTextField.borderStyle = .roundedRect
        return inviteCodeTextField
    }()
    
    lazy var yourNameLabel: UILabel = {
        let yourNameLabel = UILabel()
        yourNameLabel.text = "Your Name"
        yourNameLabel.textColor = .black
        yourNameLabel.font = UIFont.avenirNextRegular(size: 24)
        return yourNameLabel
    }()
    
    lazy var yourNameTextField: UITextField = {
        let yourNameTextField = UITextField()
        yourNameTextField.textColor = .black
        yourNameTextField.borderStyle = .roundedRect
        return yourNameTextField
    }()
    
    lazy var joinButton: UIButton = {
        let joinButton = UIButton()
        joinButton.setTitle("Join Party", for: .normal)
        joinButton.setTitleColor(.black, for: .normal)
        joinButton.setTitleFont(UIFont.avenirNextRegularName, size: 24)
        return joinButton
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
        self.addSubview(self.backgroundButton)
        self.addSubview(self.inviteCodeLabel)
        self.addSubview(self.inviteCodeTextField)
        self.addSubview(self.yourNameLabel)
        self.addSubview(self.yourNameTextField)
        self.addSubview(self.joinButton)
        
        self.backgroundButton.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        self.inviteCodeLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(30)
            make.top.equalTo(self.snp.top).offset(30)
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
