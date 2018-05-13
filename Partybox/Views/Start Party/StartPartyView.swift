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

    private lazy var partyNameLabel: UILabel = {
        let partyNameLabel = UILabel()
        partyNameLabel.text = "Party Name"
        partyNameLabel.font = UIFont.Partybox.avenirNextRegular(size: 20)
        partyNameLabel.textColor = UIColor.Partybox.black
        return partyNameLabel
    }()

    private lazy var partyNameTextField: UITextField = {
        let partyNameTextField = UITextField()
        partyNameTextField.delegate = self
        partyNameTextField.font = UIFont.Partybox.avenirNextRegular(size: 28)
        partyNameTextField.textColor = UIColor.Partybox.black
        partyNameTextField.tintColor = UIColor.Partybox.red
        partyNameTextField.borderStyle = .none
        partyNameTextField.autocapitalizationType = .words
        partyNameTextField.clearButtonMode = .whileEditing
        return partyNameTextField
    }()

    private lazy var partyNameUnderlineLabel: UILabel = {
        let partyNameUnderlineLabel = UILabel()
        partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
        return partyNameUnderlineLabel
    }()

    private lazy var partyNameStatusLabel: UILabel = {
        let partyNameStatusLabel = UILabel()
        partyNameStatusLabel.text = " "
        partyNameStatusLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        partyNameStatusLabel.textColor = UIColor.Partybox.red
        partyNameStatusLabel.isHidden = true
        return partyNameStatusLabel
    }()

    private lazy var partyNameMaxCharacterCount: Int = 15

    private lazy var partyNameCharacterCountLabel: UILabel = {
        let partyNameCharacterCountLabel = UILabel()
        partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount)"
        partyNameCharacterCountLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        partyNameCharacterCountLabel.textColor = UIColor.lightGray
        return partyNameCharacterCountLabel
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
        userNameTextField.tintColor = UIColor.Partybox.red
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

    private lazy var startPartyButton: ActivityIndicatorButton = {
        let startPartyButton = ActivityIndicatorButton()
        startPartyButton.setTitle("Start Party", for: .normal)
        startPartyButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        startPartyButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        startPartyButton.setBackgroundColor(UIColor.Partybox.red)
        startPartyButton.addTarget(self, action: #selector(startPartyButtonPressed), for: .touchUpInside)
        return startPartyButton
    }()

    private var delegate: StartPartyViewDelegate!

    // MARK: - Construction Functions

    static func construct(delegate: StartPartyViewDelegate) -> StartPartyView {
        let view = StartPartyView()
        view.delegate = delegate
        view.setupView()
        return view
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = .white
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        self.addSubview(self.partyNameLabel)
        self.addSubview(self.partyNameTextField)
        self.addSubview(self.partyNameCharacterCountLabel)
        self.addSubview(self.partyNameUnderlineLabel)
        self.addSubview(self.partyNameStatusLabel)
        self.addSubview(self.userNameLabel)
        self.addSubview(self.userNameTextField)
        self.addSubview(self.userNameCharacterCountLabel)
        self.addSubview(self.userNameUnderlineLabel)
        self.addSubview(self.userNameStatusLabel)
        self.addSubview(self.startPartyButton)

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
            make.centerY.equalTo(self.partyNameTextField.snp.centerY)
            make.leading.equalTo(self.partyNameTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
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

        self.userNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyNameStatusLabel.snp.bottom).offset(40)
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

        self.startPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Action Functions

    @objc private func hideKeyboard() {
        self.partyNameTextField.resignFirstResponder()
        self.userNameTextField.resignFirstResponder()
    }
    
    @objc private func startPartyButtonPressed() {
        let partyNameHasErrors = self.partyNameHasErrors()
        let userNameHasErrors = self.userNameHasErrors()

        if partyNameHasErrors || userNameHasErrors {
            return
        }

        self.delegate.startPartyView(self, startPartyButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingStartPartyButton() {
        self.startPartyButton.startAnimating()
    }

    func stopAnimatingStartPartyButton() {
        self.startPartyButton.stopAnimating()
    }
    
    // MARK: - View Functions

    private func partyNameHasErrors() -> Bool {
        let partyName = self.partyNameTextField.text!

        if partyName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.red
            self.partyNameStatusLabel.text = "Required"
            self.partyNameStatusLabel.isHidden = false
            return true
        } else {
            self.partyNameUnderlineLabel.backgroundColor = UIColor.Partybox.black
            self.partyNameStatusLabel.text = " "
            self.partyNameStatusLabel.isHidden = true
            return false
        }
    }
    
    func partyName() -> String {
        return self.partyNameTextField.text!
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

extension StartPartyView: UITextFieldDelegate {

    // MARK: - Text Field Delegate Functions

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length

        if textField == self.partyNameTextField && characterCount <= self.partyNameMaxCharacterCount {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount - characterCount)"
            return true
        }

        if textField == self.userNameTextField && characterCount <= self.userNameMaxCharacterCount {
            self.userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount - characterCount)"
            return true
        }

        return false
    }

    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.partyNameTextField {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount)"
        }

        if textField == self.userNameTextField {
            self.userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount)"
        }

        return true
    }

}
