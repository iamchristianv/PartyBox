//
//  StartPartyTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 2/18/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyTableViewCell: UITableViewCell {
    
    // MARK: - Class Properties
    
    static let identifier: String = String(describing: StartPartyTableViewCell.self)

    // MARK: - Instance Properties
    
    lazy var partyNameLabel: UILabel = {
        let partyNameLabel = UILabel()
        partyNameLabel.text = "Party Name"
        partyNameLabel.font = UIFont.avenirNextRegular(size: 20)
        partyNameLabel.textColor = UIColor.Partybox.black
        return partyNameLabel
    }()
    
    lazy var partyNameTextField: UITextField = {
        let partyNameTextField = UITextField()
        partyNameTextField.delegate = self
        partyNameTextField.font = UIFont.avenirNextRegular(size: 28)
        partyNameTextField.textColor = UIColor.Partybox.black
        partyNameTextField.tintColor = UIColor.Partybox.red
        partyNameTextField.borderStyle = .none
        partyNameTextField.autocapitalizationType = .words
        partyNameTextField.clearButtonMode = .whileEditing
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
        partyNameStatusLabel.font = UIFont.avenirNextRegular(size: 16)
        partyNameStatusLabel.textColor = UIColor.Partybox.red
        partyNameStatusLabel.isHidden = true
        return partyNameStatusLabel
    }()
    
    lazy var partyNameMaxCharacterCount: Int = 15
    
    lazy var partyNameCharacterCountLabel: UILabel = {
        let partyNameCharacterCountLabel = UILabel()
        partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount)"
        partyNameCharacterCountLabel.font = UIFont.avenirNextRegular(size: 16)
        partyNameCharacterCountLabel.textColor = UIColor.lightGray
        return partyNameCharacterCountLabel
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
        yourNameTextField.tintColor = UIColor.Partybox.red
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
    
    // MARK: - Initialization Functions
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
        self.selectionStyle = .none
    }
    
    func setupSubviews() {
        self.addSubview(self.partyNameLabel)
        self.addSubview(self.partyNameTextField)
        self.addSubview(self.partyNameCharacterCountLabel)
        self.addSubview(self.partyNameUnderlineLabel)
        self.addSubview(self.partyNameStatusLabel)
        self.addSubview(self.yourNameLabel)
        self.addSubview(self.yourNameTextField)
        self.addSubview(self.yourNameCharacterCountLabel)
        self.addSubview(self.yourNameUnderlineLabel)
        self.addSubview(self.yourNameStatusLabel)
        
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
            make.trailing.equalTo(self.partyNameCharacterCountLabel.snp.leading).offset(-4)
            make.top.equalTo(self.partyNameLabel.snp.bottom)
        })
        
        self.partyNameCharacterCountLabel.snp.remakeConstraints({
            (make) in
            
            make.width.lessThanOrEqualTo(20)
            make.leading.equalTo(self.partyNameTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.centerY.equalTo(self.partyNameTextField.snp.centerY)
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
            make.top.equalTo(self.partyNameStatusLabel.snp.bottom).offset(40)
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
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
        
    // MARK: - View Functions
    
    func hideKeyboard() {
        self.partyNameTextField.resignFirstResponder()
        self.yourNameTextField.resignFirstResponder()
    }
    
    func partyNameValueHasErrors() -> Bool {
        let partyName = self.partyNameTextField.text!
        
        if partyName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showPartyNameRequiredStatus()
            return true
        } else {
            self.hidePartyNameStatus()
            return false
        }
    }
    
    func showPartyNameRequiredStatus() {
        self.partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
        self.partyNameStatusLabel.text = "Required"
        self.partyNameStatusLabel.isHidden = false
    }
    
    func hidePartyNameStatus() {
        self.partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        self.partyNameStatusLabel.text = " "
        self.partyNameStatusLabel.isHidden = true
    }
    
    func partyNameValue() -> String {
        return self.partyNameTextField.text!
    }
    
    func yourNameValueHasErrors() -> Bool {
        let userName = self.yourNameTextField.text!
        
        if userName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showYourNameRequiredStatus()
            return true
        } else if !userName.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.showYourNameInvalidStatus()
            return true
        } else {
            self.hideYourNameStatus()
            return false
        }
    }
    
    func showYourNameRequiredStatus() {
        self.yourNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
        self.yourNameStatusLabel.text = "Required"
        self.yourNameStatusLabel.isHidden = false
    }
    
    func showYourNameInvalidStatus() {
        self.yourNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
        self.yourNameStatusLabel.text = "No spaces or special characters"
        self.yourNameStatusLabel.isHidden = false
    }
    
    func hideYourNameStatus() {
        self.yourNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        self.yourNameStatusLabel.text = " "
        self.yourNameStatusLabel.isHidden = true
    }
    
    func yourNameValue() -> String {
        return self.yourNameTextField.text!
    }

}

extension StartPartyTableViewCell: UITextFieldDelegate {
    
    // MARK: - Text Field Delegate Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length
        
        if textField == self.partyNameTextField && characterCount <= self.partyNameMaxCharacterCount {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount - characterCount)"
            return true
        }
        
        if textField == self.yourNameTextField && characterCount <= self.yourNameMaxCharacterCount {
            self.yourNameCharacterCountLabel.text = "\(self.yourNameMaxCharacterCount - characterCount)"
            return true
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.partyNameTextField {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount)"
        }
        
        if textField == self.yourNameTextField {
            self.yourNameCharacterCountLabel.text = "\(self.yourNameMaxCharacterCount)"
        }
        
        return true
    }
    
}
