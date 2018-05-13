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

    private lazy var partyIdLabel: UILabel = {
        let partyIdLabel = UILabel()
        partyIdLabel.text = "Invite Code"
        partyIdLabel.font = UIFont.Partybox.avenirNextRegular(size: 20)
        partyIdLabel.textColor = UIColor.Partybox.black
        return partyIdLabel
    }()

    private lazy var partyIdTextField: UITextField = {
        let partyIdTextField = UITextField()
        partyIdTextField.delegate = self
        partyIdTextField.font = UIFont.Partybox.avenirNextRegular(size: 28)
        partyIdTextField.textColor = UIColor.Partybox.black
        partyIdTextField.tintColor = UIColor.Partybox.blue
        partyIdTextField.borderStyle = .none
        partyIdTextField.autocapitalizationType = .allCharacters
        partyIdTextField.clearButtonMode = .whileEditing
        return partyIdTextField
    }()

    private lazy var partyIdUnderlineLabel: UILabel = {
        let partyIdUnderlineLabel = UILabel()
        partyIdUnderlineLabel.backgroundColor = UIColor.Partybox.black
        return partyIdUnderlineLabel
    }()

    private lazy var partyIdStatusLabel: UILabel = {
        let partyIdStatusLabel = UILabel()
        partyIdStatusLabel.text = " "
        partyIdStatusLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        partyIdStatusLabel.textColor = UIColor.Partybox.red
        partyIdStatusLabel.isHidden = true
        return partyIdStatusLabel
    }()

    private lazy var partyIdMaxCharacterCount: Int = 5

    private lazy var partyIdCharacterCountLabel: UILabel = {
        let partyIdCharacterCountLabel = UILabel()
        partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount)"
        partyIdCharacterCountLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        partyIdCharacterCountLabel.textColor = UIColor.lightGray
        return partyIdCharacterCountLabel
    }()

    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Your Name"
        userNameLabel.font = UIFont.Partybox.avenirNextRegular(size: 20)
        userNameLabel.textColor = UIColor.Partybox.black
        return userNameLabel
    }()

    private lazy var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.delegate = self
        userNameTextField.font = UIFont.Partybox.avenirNextRegular(size: 28)
        userNameTextField.textColor = UIColor.Partybox.black
        userNameTextField.tintColor = UIColor.Partybox.blue
        userNameTextField.borderStyle = .none
        userNameTextField.autocapitalizationType = .words
        userNameTextField.clearButtonMode = .whileEditing
        return userNameTextField
    }()

    private lazy var userNameUnderlineLabel: UILabel = {
        let userNameUnderlineLabel = UILabel()
        userNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        return userNameUnderlineLabel
    }()

    private lazy var userNameStatusLabel: UILabel = {
        let userNameStatusLabel = UILabel()
        userNameStatusLabel.text = " "
        userNameStatusLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        userNameStatusLabel.textColor = UIColor.Partybox.red
        userNameStatusLabel.isHidden = true
        return userNameStatusLabel
    }()

    private lazy var userNameMaxCharacterCount: Int = 15

    private lazy var userNameCharacterCountLabel: UILabel = {
        let userNameCharacterCountLabel = UILabel()
        userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount)"
        userNameCharacterCountLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        userNameCharacterCountLabel.textColor = UIColor.lightGray
        return userNameCharacterCountLabel
    }()

    private lazy var joinPartyButton: ActivityIndicatorButton = {
        let joinPartyButton = ActivityIndicatorButton()
        joinPartyButton.setTitle("Join Party", for: .normal)
        joinPartyButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        joinPartyButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        joinPartyButton.setBackgroundColor(UIColor.Partybox.blue)
        joinPartyButton.addTarget(self, action: #selector(joinPartyButtonPressed), for: .touchUpInside)
        return joinPartyButton
    }()

    private var delegate: JoinPartyViewDelegate!

    // MARK: - Construction Functions

    static func construct(delegate: JoinPartyViewDelegate) -> JoinPartyView {
        let view = JoinPartyView()
        view.delegate = delegate
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = .white
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        self.addSubview(self.partyIdLabel)
        self.addSubview(self.partyIdTextField)
        self.addSubview(self.partyIdCharacterCountLabel)
        self.addSubview(self.partyIdUnderlineLabel)
        self.addSubview(self.partyIdStatusLabel)
        self.addSubview(self.userNameLabel)
        self.addSubview(self.userNameTextField)
        self.addSubview(self.userNameCharacterCountLabel)
        self.addSubview(self.userNameUnderlineLabel)
        self.addSubview(self.userNameStatusLabel)
        self.addSubview(self.joinPartyButton)
        
        self.partyIdLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })

        self.partyIdTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.partyIdCharacterCountLabel.snp.leading).offset(-4)
            make.top.equalTo(self.partyIdLabel.snp.bottom)
        })

        self.partyIdCharacterCountLabel.snp.remakeConstraints({
            (make) in

            make.width.lessThanOrEqualTo(20)
            make.centerY.equalTo(self.partyIdTextField.snp.centerY)
            make.leading.equalTo(self.partyIdTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
        })

        self.partyIdUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyIdTextField.snp.bottom)
        })

        self.partyIdStatusLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyIdUnderlineLabel.snp.bottom).offset(8)
        })

        self.userNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyIdStatusLabel.snp.bottom).offset(40)
        })

        self.userNameTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.userNameCharacterCountLabel.snp.leading).offset(-4)
            make.top.equalTo(self.userNameLabel.snp.bottom)
        })

        self.userNameCharacterCountLabel.snp.remakeConstraints({
            (make) in

            make.width.lessThanOrEqualTo(20)
            make.centerY.equalTo(self.userNameTextField.snp.centerY)
            make.leading.equalTo(self.userNameTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
        })

        self.userNameUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.userNameTextField.snp.bottom)
        })

        self.userNameStatusLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.userNameUnderlineLabel.snp.bottom).offset(8)
        })
        
        self.joinPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions

    @objc private func hideKeyboard() {
        self.partyIdTextField.resignFirstResponder()
        self.userNameTextField.resignFirstResponder()
    }
    
    @objc private func joinPartyButtonPressed() {
        let partyIdHasErrors = self.partyIdHasErrors()
        let userNameHasErrors = self.userNameHasErrors()

        if partyIdHasErrors || userNameHasErrors {
            return
        }

        self.delegate.joinPartyView(self, joinPartyButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingJoinPartyButton() {
        self.joinPartyButton.startAnimating()
    }

    func stopAnimatingJoinPartyButton() {
        self.joinPartyButton.stopAnimating()
    }
    
    // MARK: - View Functions
    
    private func partyIdHasErrors() -> Bool {
        let partyId = self.partyIdTextField.text!

        if partyId.trimmingCharacters(in: .whitespaces).isEmpty {
            self.partyIdUnderlineLabel.backgroundColor = UIColor.Partybox.red
            self.partyIdStatusLabel.text = "Required"
            self.partyIdStatusLabel.isHidden = false
            return true
        } else if !partyId.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.partyIdUnderlineLabel.backgroundColor = UIColor.Partybox.red
            self.partyIdStatusLabel.text = "No spaces or special characters"
            self.partyIdStatusLabel.isHidden = false
            return true
        } else {
            self.partyIdUnderlineLabel.backgroundColor = UIColor.Partybox.black
            self.partyIdStatusLabel.text = " "
            self.partyIdStatusLabel.isHidden = true
            return false
        }
    }

    func partyId() -> String {
        return self.partyIdTextField.text!
    }

    private func userNameHasErrors() -> Bool {
        let userName = self.userNameTextField.text!

        if userName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.userNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
            self.userNameStatusLabel.text = "Required"
            self.userNameStatusLabel.isHidden = false
            return true
        } else if !userName.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.userNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
            self.userNameStatusLabel.text = "No spaces or special characters"
            self.userNameStatusLabel.isHidden = false
            return true
        } else {
            self.userNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
            self.userNameStatusLabel.text = " "
            self.userNameStatusLabel.isHidden = true
            return false
        }
    }

    func userName() -> String {
        return self.userNameTextField.text!
    }
    
}

extension JoinPartyView: UITextFieldDelegate {

    // MARK: - Text Field Delegate Functions

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length

        if textField == self.partyIdTextField && characterCount <= self.partyIdMaxCharacterCount {
            self.partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount - characterCount)"
            return true
        }

        if textField == self.userNameTextField && characterCount <= self.userNameMaxCharacterCount {
            self.userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount - characterCount)"
            return true
        }

        return false
    }

    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.partyIdTextField {
            self.partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount)"
        }

        if textField == self.userNameTextField {
            self.userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount)"
        }

        return true
    }

}
