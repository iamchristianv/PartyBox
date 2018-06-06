//
//  ManagePartyView.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyView: UIView {
    
    // MARK: - Instance Properties
    
    private lazy var partyNameLabel: UILabel = {
        let partyNameLabel = UILabel()
        partyNameLabel.text = "Party Name"
        partyNameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        partyNameLabel.textColor = Partybox.colors.black
        return partyNameLabel
    }()

    private lazy var partyNameTextField: UITextField = {
        let partyNameTextField = UITextField()
        partyNameTextField.delegate = self
        partyNameTextField.text = self.dataSource.managePartyViewPartyName()
        partyNameTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        partyNameTextField.textColor = Partybox.colors.black
        partyNameTextField.tintColor = Partybox.colors.green
        partyNameTextField.borderStyle = .none
        partyNameTextField.autocapitalizationType = .words
        partyNameTextField.clearButtonMode = .whileEditing
        return partyNameTextField
    }()

    private lazy var partyNameUnderlineLabel: UILabel = {
        let partyNameUnderlineLabel = UILabel()
        partyNameUnderlineLabel.backgroundColor = Partybox.colors.black
        return partyNameUnderlineLabel
    }()

    private lazy var partyNameStatusLabel: UILabel = {
        let partyNameStatusLabel = UILabel()
        partyNameStatusLabel.text = " "
        partyNameStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        partyNameStatusLabel.textColor = Partybox.colors.red
        partyNameStatusLabel.isHidden = true
        return partyNameStatusLabel
    }()

    private lazy var partyNameMaxCharacterCount: Int = 15

    private lazy var partyNameCharacterCountLabel: UILabel = {
        let partyNameCharacterCountLabel = UILabel()
        partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount - self.dataSource.managePartyViewPartyHostName().count)"
        partyNameCharacterCountLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        partyNameCharacterCountLabel.textColor = UIColor.lightGray
        return partyNameCharacterCountLabel
    }()

    private lazy var partyHostNameLabel: UILabel = {
        let partyHostNameLabel = UILabel()
        partyHostNameLabel.text = "Party Host"
        partyHostNameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        partyHostNameLabel.textColor = Partybox.colors.black
        return partyHostNameLabel
    }()
    
    private lazy var partyHostNameTextField: UITextField = {
        let partyHostNameTextField = UITextField()
        partyHostNameTextField.delegate = self
        partyHostNameTextField.text = self.dataSource.managePartyViewPartyHostName()
        partyHostNameTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        partyHostNameTextField.textColor = Partybox.colors.black
        partyHostNameTextField.borderStyle = .none
        return partyHostNameTextField
    }()

    private lazy var partyHostNameUnderlineLabel: UILabel = {
        let partyHostNameUnderlineLabel = UILabel()
        partyHostNameUnderlineLabel.backgroundColor = Partybox.colors.black
        return partyHostNameUnderlineLabel
    }()
    
    private lazy var saveButton: ActivityIndicatorButton = {
        let saveButton = ActivityIndicatorButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        saveButton.setTitleColor(Partybox.colors.white, for: .normal)
        saveButton.setBackgroundColor(Partybox.colors.green)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return saveButton
    }()

    var partyName: String {
        set {
            self.partyNameTextField.text = newValue
        }
        get {
            return self.partyNameTextField.text!
        }
    }

    var partyHostName: String {
        set {
            self.partyHostNameTextField.text = newValue
        }
        get {
            return self.partyHostNameTextField.text!
        }
    }
    
    private var delegate: ManagePartyViewDelegate!

    private var dataSource: ManagePartyViewDataSource!
    
    // MARK: - Construction Functions

    static func construct(delegate: ManagePartyViewDelegate, dataSource: ManagePartyViewDataSource) -> ManagePartyView {
        let view = ManagePartyView()
        view.delegate = delegate
        view.dataSource = dataSource
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
        self.addSubview(self.partyHostNameLabel)
        self.addSubview(self.partyHostNameTextField)
        self.addSubview(self.partyHostNameUnderlineLabel)
        self.addSubview(self.saveButton)

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

        self.partyHostNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyNameStatusLabel.snp.bottom).offset(40)
        })

        self.partyHostNameTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyHostNameLabel.snp.bottom)
        })

        self.partyHostNameUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.partyHostNameTextField.snp.bottom)
        })
        
        self.saveButton.snp.remakeConstraints({
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
    }
    
    @objc private func saveButtonPressed() {
        let partyNameHasErrors = self.partyNameHasErrors()

        if partyNameHasErrors {
            return
        }

        self.delegate.managePartyView(self, saveButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingSaveButton() {
        self.saveButton.startAnimating()
    }

    func stopAnimatingSaveButton() {
        self.saveButton.stopAnimating()
    }
    
    // MARK: - View Functions

    private func partyNameHasErrors() -> Bool {
        if self.partyNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.partyNameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.partyNameStatusLabel.text = "Required"
            self.partyNameStatusLabel.isHidden = false
            return true
        }

        self.partyNameUnderlineLabel.backgroundColor = Partybox.colors.black
        self.partyNameStatusLabel.text = " "
        self.partyNameStatusLabel.isHidden = true
        return false
    }

}

extension ManagePartyView: UITextFieldDelegate {

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.partyHostNameTextField {
            self.delegate.managePartyView(self, partyHostNameTextFieldPressed: true)
            return false
        }

        return true
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length

        if textField == self.partyNameTextField && characterCount <= self.partyNameMaxCharacterCount {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount - characterCount)"
            return true
        }

        return false
    }

    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.partyNameTextField {
            self.partyNameCharacterCountLabel.text = "\(self.partyNameMaxCharacterCount)"
        }

        return true
    }

}
