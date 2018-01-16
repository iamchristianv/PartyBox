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
    
    lazy var backgroundButton: UIButton = {
        let backgroundButton = UIButton()
        return backgroundButton
    }()
    
    lazy var partyNameLabel: UILabel = {
        let partyNameLabel = UILabel()
        partyNameLabel.text = "Party Name"
        partyNameLabel.font = UIFont.avenirNextRegular(size: 24)
        partyNameLabel.textColor = UIColor.Partybox.black
        return partyNameLabel
    }()
    
    lazy var partyNameTextField: UITextField = {
        let partyNameTextField = UITextField()
        partyNameTextField.font = UIFont.avenirNextRegular(size: 20)
        partyNameTextField.textColor = UIColor.Partybox.black
        partyNameTextField.tintColor = UIColor.Partybox.red
        partyNameTextField.borderStyle = .none
        partyNameTextField.autocapitalizationType = .words
        return partyNameTextField
    }()
    
    lazy var partyNameUnderlineLabel: UILabel = {
        let partyNameUnderlineLabel = UILabel()
        partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        return partyNameUnderlineLabel
    }()
    
    lazy var partyNameStatusLabel: UILabel = {
        let partyNameStatusLabel = UILabel()
        partyNameStatusLabel.text = " "
        partyNameStatusLabel.font = UIFont.avenirNextRegular(size: 14)
        partyNameStatusLabel.textColor = UIColor.Partybox.red
        partyNameStatusLabel.isHidden = true
        return partyNameStatusLabel
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
        yourNameTextField.tintColor = UIColor.Partybox.red
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
        continueButton.setBackgroundColor(UIColor.Partybox.red)
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
        self.addSubview(self.partyNameLabel)
        self.addSubview(self.partyNameTextField)
        self.addSubview(self.partyNameUnderlineLabel)
        self.addSubview(self.partyNameStatusLabel)
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

        self.partyNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })
        
        self.partyNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyNameLabel.snp.bottom)
        })
        
        self.partyNameUnderlineLabel.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyNameTextField.snp.bottom)
        })
        
        self.partyNameStatusLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyNameUnderlineLabel.snp.bottom).offset(8)
        })
        
        self.yourNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyNameStatusLabel.snp.bottom).offset(56)
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
    
    // MARK: - Status Methods
    
    func showPartyNameStatus(_ status: String) {
        self.partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
        self.partyNameStatusLabel.text = status
        self.partyNameStatusLabel.isHidden = false
    }
    
    func hidePartyNameStatus() {
        self.partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        self.partyNameStatusLabel.text = " "
        self.partyNameStatusLabel.isHidden = true
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
    
    // MARK: - Animation Methods
    
    func startAnimatingContinueButton() {
        self.continueButton.startAnimating()
    }
    
    func stopAnimatingContinueButton() {
        self.continueButton.stopAnimating()
    }

}
