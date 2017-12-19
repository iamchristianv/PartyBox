//
//  StartPartyView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyView: BaseView {

    // MARK: - Instance Properties
    
    lazy var backgroundButton: UIButton = {
        let backgroundButton = UIButton()
        return backgroundButton
    }()
    
    lazy var partyNameLabel: UILabel = {
        let partyNameLabel = UILabel()
        partyNameLabel.text = "Party Name"
        partyNameLabel.textColor = .black
        partyNameLabel.font = UIFont.avenirNextRegular(size: 24)
        return partyNameLabel
    }()
    
    lazy var partyNameTextField: UITextField = {
        let partyNameTextField = UITextField()
        partyNameTextField.textColor = .black
        partyNameTextField.borderStyle = .roundedRect
        return partyNameTextField
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
    
    lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.setTitle("Start Party", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleFont(UIFont.avenirNextRegularName, size: 24)
        return startButton
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
        self.addSubview(self.partyNameLabel)
        self.addSubview(self.partyNameTextField)
        self.addSubview(self.yourNameLabel)
        self.addSubview(self.yourNameTextField)
        self.addSubview(self.startButton)
        
        self.backgroundButton.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })

        self.partyNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.top.equalTo(self.snp.top).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.bottom.equalTo(self.partyNameTextField.snp.top).offset(-16)
        })
        
        self.partyNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.top.equalTo(self.partyNameLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.bottom.equalTo(self.yourNameLabel.snp.top).offset(-64)
        })
        
        self.yourNameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.top.equalTo(self.partyNameTextField.snp.bottom).offset(64)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.bottom.equalTo(self.yourNameTextField.snp.top).offset(-16)
        })
        
        self.yourNameTextField.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(40)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.top.equalTo(self.yourNameLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.bottom.equalTo(self.startButton.snp.top).offset(-64)
        })
        
        self.startButton.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.yourNameTextField.snp.bottom).offset(64)
        })
    }

}
