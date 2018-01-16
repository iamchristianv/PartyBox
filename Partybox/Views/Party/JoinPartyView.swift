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
    
    lazy var backgroundButton: UIButton = {
        let backgroundButton = UIButton()
        return backgroundButton
    }()
    
    lazy var inviteCodeLabel: UILabel = {
        let inviteCodeLabel = UILabel()
        inviteCodeLabel.text = "Invite Code"
        inviteCodeLabel.font = UIFont.avenirNextRegular(size: 24)
        inviteCodeLabel.textColor = UIColor.Partybox.black
        return inviteCodeLabel
    }()
    
    lazy var inviteCodeTextField: UITextField = {
        let inviteCodeTextField = UITextField()
        inviteCodeTextField.font = UIFont.avenirNextRegular(size: 20)
        inviteCodeTextField.textColor = UIColor.Partybox.black
        inviteCodeTextField.tintColor = UIColor.Partybox.blue
        inviteCodeTextField.borderStyle = .none
        inviteCodeTextField.autocapitalizationType = .allCharacters
        return inviteCodeTextField
    }()
    
    lazy var inviteCodeUnderlineLabel: UILabel = {
        let inviteCodeUnderlineLabel = UILabel()
        inviteCodeUnderlineLabel.backgroundColor = UIColor.Partybox.black
        return inviteCodeUnderlineLabel
    }()
    
    lazy var inviteCodeStatusLabel: UILabel = {
        let inviteCodeStatusLabel = UILabel()
        inviteCodeStatusLabel.text = " "
        inviteCodeStatusLabel.font = UIFont.avenirNextRegular(size: 14)
        inviteCodeStatusLabel.textColor = UIColor.Partybox.red
        inviteCodeStatusLabel.isHidden = true
        return inviteCodeStatusLabel
    }()
    
    lazy var yourNameLabel: UILabel = {
        let yourNameLabel = UILabel()
        yourNameLabel.text = "Your Name"
        yourNameLabel.font = UIFont.avenirNextRegular(size: 24)
        yourNameLabel.textColor = UIColor.Partybox.black
        return yourNameLabel
    }()
    
    lazy var yourNameTextField: UITextField = {
        let yourNameTextField = UITextField()
        yourNameTextField.font = UIFont.avenirNextRegular(size: 20)
        yourNameTextField.textColor = UIColor.Partybox.black
        yourNameTextField.tintColor = UIColor.Partybox.blue
        yourNameTextField.borderStyle = .none
        yourNameTextField.autocapitalizationType = .words
        return yourNameTextField
    }()
    
    lazy var yourNameUnderlineLabel: UILabel = {
        let yourNameUnderlineLabel = UILabel()
        yourNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        return yourNameUnderlineLabel
    }()
    
    lazy var yourNameStatusLabel: UILabel = {
        let yourNameStatusLabel = UILabel()
        yourNameStatusLabel.text = " "
        yourNameStatusLabel.font = UIFont.avenirNextRegular(size: 14)
        yourNameStatusLabel.textColor = UIColor.Partybox.red
        yourNameStatusLabel.isHidden = true
        return yourNameStatusLabel
    }()
    
    lazy var continueButton: ActivityButton = {
        let continueButton = ActivityButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleFont(UIFont.avenirNextMediumName, size: 24)
        continueButton.setBackgroundColor(UIColor.Partybox.blue)
        return continueButton
    }()
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
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
        self.addSubview(self.inviteCodeUnderlineLabel)
        self.addSubview(self.inviteCodeStatusLabel)
        self.addSubview(self.yourNameLabel)
        self.addSubview(self.yourNameTextField)
        self.addSubview(self.yourNameUnderlineLabel)
        self.addSubview(self.yourNameStatusLabel)
        self.addSubview(self.continueButton)
        
        self.backgroundButton.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        self.inviteCodeLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })
        
        self.inviteCodeTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.inviteCodeLabel.snp.bottom)
        })
        
        self.inviteCodeUnderlineLabel.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.inviteCodeTextField.snp.bottom)
        })
        
        self.inviteCodeStatusLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.inviteCodeUnderlineLabel.snp.bottom).offset(8)
        })
        
        self.yourNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.inviteCodeStatusLabel.snp.bottom).offset(56)
        })
        
        self.yourNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.yourNameLabel.snp.bottom)
        })
        
        self.yourNameUnderlineLabel.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.yourNameTextField.snp.bottom)
        })
        
        self.yourNameStatusLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.yourNameUnderlineLabel.snp.bottom).offset(8)
        })
        
        self.continueButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(250)
            make.height.equalTo(62.5)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.yourNameStatusLabel.snp.bottom).offset(64)
        })
    }
    
    // MARK: - Action Methods
    
    func showInviteCodeStatus(_ status: String) {
        self.inviteCodeUnderlineLabel.backgroundColor = UIColor.Partybox.red
        self.inviteCodeStatusLabel.text = status
        self.inviteCodeStatusLabel.isHidden = false
    }
    
    func hideInviteCodeStatus() {
        self.inviteCodeUnderlineLabel.backgroundColor = UIColor.Partybox.black
        self.inviteCodeStatusLabel.text = " "
        self.inviteCodeStatusLabel.isHidden = true
    }
    
    func showYourNameStatus(_ status: String) {
        self.yourNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
        self.yourNameStatusLabel.text = status
        self.yourNameStatusLabel.isHidden = false
    }
    
    func hideYourNameStatus() {
        self.yourNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        self.yourNameStatusLabel.text = " "
        self.yourNameStatusLabel.isHidden = true
    }
    
    func startAnimatingContinueButton() {
        self.continueButton.startAnimating()
    }
    
    func stopAnimatingContinueButton() {
        self.continueButton.stopAnimating()
    }
    
}
