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
        inviteCodeLabel.font = UIFont.avenirNextRegular(size: 20)
        inviteCodeLabel.textColor = UIColor.Partybox.black
        return inviteCodeLabel
    }()
    
    lazy var inviteCodeTextField: UITextField = {
        let inviteCodeTextField = UITextField()
        inviteCodeTextField.delegate = self
        inviteCodeTextField.font = UIFont.avenirNextRegular(size: 28)
        inviteCodeTextField.textColor = UIColor.Partybox.black
        inviteCodeTextField.tintColor = UIColor.Partybox.blue
        inviteCodeTextField.borderStyle = .none
        inviteCodeTextField.autocapitalizationType = .allCharacters
        inviteCodeTextField.clearButtonMode = .whileEditing
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
        inviteCodeStatusLabel.font = UIFont.avenirNextRegular(size: 16)
        inviteCodeStatusLabel.textColor = UIColor.Partybox.red
        inviteCodeStatusLabel.isHidden = true
        return inviteCodeStatusLabel
    }()
    
    lazy var inviteCodeMaxCharacterCount: Int = 4
    
    lazy var inviteCodeCharacterCountLabel: UILabel = {
        let inviteCodeCharacterCountLabel = UILabel()
        inviteCodeCharacterCountLabel.text = "\(self.inviteCodeMaxCharacterCount)"
        inviteCodeCharacterCountLabel.font = UIFont.avenirNextRegular(size: 16)
        inviteCodeCharacterCountLabel.textColor = UIColor.lightGray
        return inviteCodeCharacterCountLabel
    }()
    
    lazy var yourNameLabel: UILabel = {
        let yourNameLabel = UILabel()
        yourNameLabel.text = "Your Name"
        yourNameLabel.font = UIFont.avenirNextRegular(size: 20)
        yourNameLabel.textColor = UIColor.Partybox.black
        return yourNameLabel
    }()
    
    lazy var yourNameTextField: UITextField = {
        let yourNameTextField = UITextField()
        yourNameTextField.delegate = self
        yourNameTextField.font = UIFont.avenirNextRegular(size: 28)
        yourNameTextField.textColor = UIColor.Partybox.black
        yourNameTextField.tintColor = UIColor.Partybox.blue
        yourNameTextField.borderStyle = .none
        yourNameTextField.autocapitalizationType = .words
        yourNameTextField.clearButtonMode = .whileEditing
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
        yourNameStatusLabel.font = UIFont.avenirNextRegular(size: 16)
        yourNameStatusLabel.textColor = UIColor.Partybox.red
        yourNameStatusLabel.isHidden = true
        return yourNameStatusLabel
    }()
    
    lazy var yourNameMaxCharacterCount: Int = 15
    
    lazy var yourNameCharacterCountLabel: UILabel = {
        let yourNameCharacterCountLabel = UILabel()
        yourNameCharacterCountLabel.text = "\(self.yourNameMaxCharacterCount)"
        yourNameCharacterCountLabel.font = UIFont.avenirNextRegular(size: 16)
        yourNameCharacterCountLabel.textColor = UIColor.lightGray
        return yourNameCharacterCountLabel
    }()
    
    lazy var continueButton: ActivityButton = {
        let continueButton = ActivityButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleFont(UIFont.avenirNextRegularName, size: 22)
        continueButton.setBackgroundColor(UIColor.Partybox.blue)
        return continueButton
    }()
    
    // MARK: - Initialization Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
        self.addSubview(self.backgroundButton)
        self.addSubview(self.inviteCodeLabel)
        self.addSubview(self.inviteCodeTextField)
        self.addSubview(self.inviteCodeCharacterCountLabel)
        self.addSubview(self.inviteCodeUnderlineLabel)
        self.addSubview(self.inviteCodeStatusLabel)
        self.addSubview(self.yourNameLabel)
        self.addSubview(self.yourNameTextField)
        self.addSubview(self.yourNameCharacterCountLabel)
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
            make.trailing.equalTo(self.inviteCodeCharacterCountLabel.snp.leading).offset(-4)
            make.top.equalTo(self.inviteCodeLabel.snp.bottom)
        })
        
        self.inviteCodeCharacterCountLabel.snp.remakeConstraints({
            (make) in
            
            make.width.lessThanOrEqualTo(20)
            make.leading.equalTo(self.inviteCodeTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.centerY.equalTo(self.inviteCodeTextField.snp.centerY)
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
            make.top.equalTo(self.inviteCodeStatusLabel.snp.bottom).offset(40)
        })
        
        self.yourNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.yourNameCharacterCountLabel.snp.leading).offset(-4)
            make.top.equalTo(self.yourNameLabel.snp.bottom)
        })
        
        self.yourNameCharacterCountLabel.snp.remakeConstraints({
            (make) in
            
            make.width.lessThanOrEqualTo(20)
            make.leading.equalTo(self.yourNameTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.centerY.equalTo(self.yourNameTextField.snp.centerY)
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
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.yourNameStatusLabel.snp.bottom).offset(64)
        })
    }
    
    // MARK: - Action Functions
    
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

extension JoinPartyView: UITextFieldDelegate {
    
    // MARK: - Text Field Delegate Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length
        
        if textField == self.inviteCodeTextField && characterCount <= self.inviteCodeMaxCharacterCount {
            self.inviteCodeCharacterCountLabel.text = "\(self.inviteCodeMaxCharacterCount - characterCount)"
            return true
        }
        
        if textField == self.yourNameTextField && characterCount <= self.yourNameMaxCharacterCount {
            self.yourNameCharacterCountLabel.text = "\(self.yourNameMaxCharacterCount - characterCount)"
            return true
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.inviteCodeTextField {
            self.inviteCodeCharacterCountLabel.text = "\(self.inviteCodeMaxCharacterCount)"
        }
        
        if textField == self.yourNameTextField {
            self.yourNameCharacterCountLabel.text = "\(self.yourNameMaxCharacterCount)"
        }
        
        return true
    }
    
}
