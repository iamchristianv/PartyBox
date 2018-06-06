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
        partyIdLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        partyIdLabel.textColor = Partybox.colors.black
        return partyIdLabel
    }()

    private lazy var partyIdTextField: UITextField = {
        let partyIdTextField = UITextField()
        partyIdTextField.delegate = self
        partyIdTextField.font = Partybox.fonts.avenirNextRegular(size: 30)
        partyIdTextField.textColor = Partybox.colors.black
        partyIdTextField.tintColor = Partybox.colors.blue
        partyIdTextField.borderStyle = .none
        partyIdTextField.autocapitalizationType = .allCharacters
        partyIdTextField.clearButtonMode = .whileEditing
        return partyIdTextField
    }()

    private lazy var partyIdUnderlineLabel: UILabel = {
        let partyIdUnderlineLabel = UILabel()
        partyIdUnderlineLabel.backgroundColor = Partybox.colors.black
        return partyIdUnderlineLabel
    }()

    private lazy var partyIdStatusLabel: UILabel = {
        let partyIdStatusLabel = UILabel()
        partyIdStatusLabel.text = " "
        partyIdStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        partyIdStatusLabel.textColor = Partybox.colors.red
        partyIdStatusLabel.isHidden = true
        return partyIdStatusLabel
    }()

    private lazy var partyIdMaxCharacterCount: Int = 5

    private lazy var partyIdCharacterCountLabel: UILabel = {
        let partyIdCharacterCountLabel = UILabel()
        partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount)"
        partyIdCharacterCountLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        partyIdCharacterCountLabel.textColor = UIColor.lightGray
        partyIdCharacterCountLabel.textAlignment = .center
        return partyIdCharacterCountLabel
    }()

    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Your Name"
        userNameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        userNameLabel.textColor = Partybox.colors.black
        return userNameLabel
    }()

    private lazy var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.delegate = self
        userNameTextField.font = Partybox.fonts.avenirNextRegular(size: 30)
        userNameTextField.textColor = Partybox.colors.black
        userNameTextField.tintColor = Partybox.colors.blue
        userNameTextField.borderStyle = .none
        userNameTextField.autocapitalizationType = .words
        userNameTextField.clearButtonMode = .whileEditing
        return userNameTextField
    }()

    private lazy var userNameUnderlineLabel: UILabel = {
        let userNameUnderlineLabel = UILabel()
        userNameUnderlineLabel.backgroundColor = Partybox.colors.black
        return userNameUnderlineLabel
    }()

    private lazy var userNameStatusLabel: UILabel = {
        let userNameStatusLabel = UILabel()
        userNameStatusLabel.text = " "
        userNameStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        userNameStatusLabel.textColor = Partybox.colors.red
        userNameStatusLabel.isHidden = true
        return userNameStatusLabel
    }()

    private lazy var userNameMaxCharacterCount: Int = 15

    private lazy var userNameCharacterCountLabel: UILabel = {
        let userNameCharacterCountLabel = UILabel()
        userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount)"
        userNameCharacterCountLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        userNameCharacterCountLabel.textColor = UIColor.lightGray
        userNameCharacterCountLabel.textAlignment = .center
        return userNameCharacterCountLabel
    }()

    private lazy var joinButton: ActivityIndicatorButton = {
        let joinButton = ActivityIndicatorButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        joinButton.setTitleColor(Partybox.colors.white, for: .normal)
        joinButton.setBackgroundColor(Partybox.colors.blue)
        joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        return joinButton
    }()

    var partyId: String {
        set {
            self.partyIdTextField.text = newValue
        }
        get {
            return self.partyIdTextField.text!
        }
    }

    var userName: String {
        set {
            self.userNameTextField.text = newValue
        }
        get {
            return self.userNameTextField.text!
        }
    }

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
        self.addSubview(self.joinButton)
        
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

            make.width.equalTo(20)
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

            make.width.equalTo(20)
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
        
        self.joinButton.snp.remakeConstraints({
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
    
    @objc private func joinButtonPressed() {
        let partyIdHasErrors = self.partyIdHasErrors()
        let userNameHasErrors = self.userNameHasErrors()

        if partyIdHasErrors || userNameHasErrors {
            return
        }

        self.delegate.joinPartyView(self, joinButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingJoinButton() {
        self.joinButton.startAnimating()
    }

    func stopAnimatingJoinButton() {
        self.joinButton.stopAnimating()
    }
    
    // MARK: - View Functions
    
    private func partyIdHasErrors() -> Bool {
        if self.partyIdTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.partyIdUnderlineLabel.backgroundColor = Partybox.colors.red
            self.partyIdStatusLabel.text = "Required"
            self.partyIdStatusLabel.isHidden = false
            return true
        }

        if !self.partyIdTextField.text!.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.partyIdUnderlineLabel.backgroundColor = Partybox.colors.red
            self.partyIdStatusLabel.text = "No spaces or special characters"
            self.partyIdStatusLabel.isHidden = false
            return true
        }

        self.partyIdUnderlineLabel.backgroundColor = Partybox.colors.black
        self.partyIdStatusLabel.text = " "
        self.partyIdStatusLabel.isHidden = true
        return false
    }

    private func userNameHasErrors() -> Bool {
        if self.userNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.userNameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.userNameStatusLabel.text = "Required"
            self.userNameStatusLabel.isHidden = false
            return true
        }

        if !self.userNameTextField.text!.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.userNameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.userNameStatusLabel.text = "No spaces or special characters"
            self.userNameStatusLabel.isHidden = false
            return true
        }

        self.userNameUnderlineLabel.backgroundColor = Partybox.colors.black
        self.userNameStatusLabel.text = " "
        self.userNameStatusLabel.isHidden = true
        return false
    }
    
}

extension JoinPartyView: UITextFieldDelegate {

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
