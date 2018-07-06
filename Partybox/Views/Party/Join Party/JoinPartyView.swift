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
        partyIdLabel.font = Partybox.font.avenirNextRegular(size: 20)
        partyIdLabel.textColor = Partybox.color.black
        return partyIdLabel
    }()

    private lazy var partyIdTextField: UITextField = {
        let partyIdTextField = UITextField()
        partyIdTextField.delegate = self
        partyIdTextField.font = Partybox.font.avenirNextRegular(size: 30)
        partyIdTextField.textColor = Partybox.color.black
        partyIdTextField.tintColor = Partybox.color.blue
        partyIdTextField.borderStyle = .none
        partyIdTextField.autocapitalizationType = .allCharacters
        partyIdTextField.clearButtonMode = .whileEditing
        return partyIdTextField
    }()

    private lazy var partyIdUnderlineLabel: UILabel = {
        let partyIdUnderlineLabel = UILabel()
        partyIdUnderlineLabel.backgroundColor = Partybox.color.black
        return partyIdUnderlineLabel
    }()

    private lazy var partyIdStatusLabel: UILabel = {
        let partyIdStatusLabel = UILabel()
        partyIdStatusLabel.text = " "
        partyIdStatusLabel.font = Partybox.font.avenirNextRegular(size: 16)
        partyIdStatusLabel.textColor = Partybox.color.red
        partyIdStatusLabel.isHidden = true
        return partyIdStatusLabel
    }()

    private lazy var partyIdMaxCharacterCount: Int = 5

    private lazy var partyIdCharacterCountLabel: UILabel = {
        let partyIdCharacterCountLabel = UILabel()
        partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount)"
        partyIdCharacterCountLabel.font = Partybox.font.avenirNextRegular(size: 16)
        partyIdCharacterCountLabel.textColor = UIColor.lightGray
        partyIdCharacterCountLabel.textAlignment = .center
        return partyIdCharacterCountLabel
    }()

    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Your Name"
        userNameLabel.font = Partybox.font.avenirNextRegular(size: 20)
        userNameLabel.textColor = Partybox.color.black
        return userNameLabel
    }()

    private lazy var userNameTextField: UITextField = {
        let userNameTextField = UITextField()
        userNameTextField.delegate = self
        userNameTextField.font = Partybox.font.avenirNextRegular(size: 30)
        userNameTextField.textColor = Partybox.color.black
        userNameTextField.tintColor = Partybox.color.blue
        userNameTextField.borderStyle = .none
        userNameTextField.autocapitalizationType = .words
        userNameTextField.clearButtonMode = .whileEditing
        return userNameTextField
    }()

    private lazy var userNameUnderlineLabel: UILabel = {
        let userNameUnderlineLabel = UILabel()
        userNameUnderlineLabel.backgroundColor = Partybox.color.black
        return userNameUnderlineLabel
    }()

    private lazy var userNameStatusLabel: UILabel = {
        let userNameStatusLabel = UILabel()
        userNameStatusLabel.text = " "
        userNameStatusLabel.font = Partybox.font.avenirNextRegular(size: 16)
        userNameStatusLabel.textColor = Partybox.color.red
        userNameStatusLabel.isHidden = true
        return userNameStatusLabel
    }()

    private lazy var userNameMaxCharacterCount: Int = 15

    private lazy var userNameCharacterCountLabel: UILabel = {
        let userNameCharacterCountLabel = UILabel()
        userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount)"
        userNameCharacterCountLabel.font = Partybox.font.avenirNextRegular(size: 16)
        userNameCharacterCountLabel.textColor = UIColor.lightGray
        userNameCharacterCountLabel.textAlignment = .center
        return userNameCharacterCountLabel
    }()

    private lazy var joinButton: ActivityIndicatorButton = {
        let joinButton = ActivityIndicatorButton()
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleFont(Partybox.font.avenirNextMediumName, size: 22)
        joinButton.setTitleColor(Partybox.color.white, for: .normal)
        joinButton.setBackgroundColor(Partybox.color.blue)
        joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        return joinButton
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
            make.bottom.equalTo(self.snp.bottom).offset(-40)
        })
    }
    
    // MARK: - Action Functions

    @objc private func hideKeyboard() {
        self.partyIdTextField.resignFirstResponder()
        self.userNameTextField.resignFirstResponder()
    }
    
    @objc private func joinButtonPressed() {
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
    
    func partyIdHasErrors() -> Bool {
        if self.partyIdTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.partyIdUnderlineLabel.backgroundColor = Partybox.color.red
            self.partyIdStatusLabel.text = "Required"
            self.partyIdStatusLabel.isHidden = false
            return true
        } else if !self.partyIdTextField.text!.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.partyIdUnderlineLabel.backgroundColor = Partybox.color.red
            self.partyIdStatusLabel.text = "No spaces or special characters"
            self.partyIdStatusLabel.isHidden = false
            return true
        }

        self.partyIdUnderlineLabel.backgroundColor = Partybox.color.black
        self.partyIdStatusLabel.text = " "
        self.partyIdStatusLabel.isHidden = true
        return false
    }

    func userNameHasErrors() -> Bool {
        if self.userNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.userNameUnderlineLabel.backgroundColor = Partybox.color.red
            self.userNameStatusLabel.text = "Required"
            self.userNameStatusLabel.isHidden = false
            return true
        } else if !self.userNameTextField.text!.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.userNameUnderlineLabel.backgroundColor = Partybox.color.red
            self.userNameStatusLabel.text = "No spaces or special characters"
            self.userNameStatusLabel.isHidden = false
            return true
        }

        self.userNameUnderlineLabel.backgroundColor = Partybox.color.black
        self.userNameStatusLabel.text = " "
        self.userNameStatusLabel.isHidden = true
        return false
    }

    func partyId() -> String {
        return self.partyIdTextField.text!
    }

    func userName() -> String {
        return self.userNameTextField.text!
    }
    
}

extension JoinPartyView: UITextFieldDelegate {

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length

        if textField == self.partyIdTextField && characterCount <= self.partyIdMaxCharacterCount {
            self.partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount - characterCount)"
            return true
        } else if textField == self.userNameTextField && characterCount <= self.userNameMaxCharacterCount {
            self.userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount - characterCount)"
            return true
        }

        return false
    }

    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.partyIdTextField {
            self.partyIdCharacterCountLabel.text = "\(self.partyIdMaxCharacterCount)"
        } else if textField == self.userNameTextField {
            self.userNameCharacterCountLabel.text = "\(self.userNameMaxCharacterCount)"
        }

        return true
    }

}
