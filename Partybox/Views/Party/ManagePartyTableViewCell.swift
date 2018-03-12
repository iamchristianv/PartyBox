//
//  ManagePartyTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 2/18/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: ManagePartyTableViewCell.self)
    
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
        partyNameTextField.tintColor = UIColor.Partybox.green
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
    
    // MARK: - Initialization Functions
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.hideKeyboard()
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
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Setter Functions
    
    func setPartyName(_ partyName: String) {
        self.partyNameTextField.text = partyName
        self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount - partyName.count)"
    }
    
    // MARK: - Action Functions
    
    func hideKeyboard() {
        self.partyNameTextField.resignFirstResponder()
    }
    
    func fetchPartyNameValue() -> String? {
        let partyName = self.partyNameTextField.text!
        
        if partyName.trimmingCharacters(in: .whitespaces).isEmpty {
            return nil
        } else {
            return partyName
        }
    }
    
    func checkPartyNameValueForErrors() {
        let partyName = self.partyNameTextField.text!
        
        if partyName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showPartyNameRequiredStatus()
        } else {
            self.hidePartyNameStatus()
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

}

extension ManagePartyTableViewCell: UITextFieldDelegate {
    
    // MARK: - Text Field Delegate Functions
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length
        
        if textField == self.partyNameTextField && characterCount <= self.partyNameMaxCharacterCount {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount - characterCount)"
            return true
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.partyNameTextField {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount)"
        }
        
        return true
    }
    
}
