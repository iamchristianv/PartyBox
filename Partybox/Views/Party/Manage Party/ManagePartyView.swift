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
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Party Name"
        nameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        nameLabel.textColor = Partybox.colors.black
        return nameLabel
    }()

    private lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.text = self.dataSource.managePartyViewName()
        nameTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        nameTextField.textColor = Partybox.colors.black
        nameTextField.tintColor = Partybox.colors.green
        nameTextField.borderStyle = .none
        nameTextField.autocapitalizationType = .words
        nameTextField.clearButtonMode = .whileEditing
        return nameTextField
    }()

    private lazy var nameUnderlineLabel: UILabel = {
        let nameUnderlineLabel = UILabel()
        nameUnderlineLabel.backgroundColor = Partybox.colors.black
        return nameUnderlineLabel
    }()

    private lazy var nameStatusLabel: UILabel = {
        let nameStatusLabel = UILabel()
        nameStatusLabel.text = " "
        nameStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        nameStatusLabel.textColor = Partybox.colors.red
        nameStatusLabel.isHidden = true
        return nameStatusLabel
    }()

    private lazy var nameMaxCharacterCount: Int = 15

    private lazy var nameCharacterCountLabel: UILabel = {
        let nameCharacterCountLabel = UILabel()
        nameCharacterCountLabel.text = "\(self.nameMaxCharacterCount - self.dataSource.managePartyViewHostName().count)"
        nameCharacterCountLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        nameCharacterCountLabel.textColor = UIColor.lightGray
        return nameCharacterCountLabel
    }()

    private lazy var hostNameLabel: UILabel = {
        let hostNameLabel = UILabel()
        hostNameLabel.text = "Party Host"
        hostNameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        hostNameLabel.textColor = Partybox.colors.black
        return hostNameLabel
    }()
    
    private lazy var hostNameTextField: UITextField = {
        let hostNameTextField = UITextField()
        hostNameTextField.delegate = self
        hostNameTextField.text = self.dataSource.managePartyViewHostName()
        hostNameTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        hostNameTextField.textColor = Partybox.colors.black
        hostNameTextField.borderStyle = .none
        return hostNameTextField
    }()

    private lazy var hostNameUnderlineLabel: UILabel = {
        let hostNameUnderlineLabel = UILabel()
        hostNameUnderlineLabel.backgroundColor = Partybox.colors.black
        return hostNameUnderlineLabel
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

        self.addSubview(self.nameLabel)
        self.addSubview(self.nameTextField)
        self.addSubview(self.nameCharacterCountLabel)
        self.addSubview(self.nameUnderlineLabel)
        self.addSubview(self.nameStatusLabel)
        self.addSubview(self.hostNameLabel)
        self.addSubview(self.hostNameTextField)
        self.addSubview(self.hostNameUnderlineLabel)
        self.addSubview(self.saveButton)

        self.nameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })

        self.nameTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.nameCharacterCountLabel.snp.leading).offset(-4)
            make.top.equalTo(self.nameLabel.snp.bottom)
        })

        self.nameCharacterCountLabel.snp.remakeConstraints({
            (make) in

            make.width.lessThanOrEqualTo(20)
            make.centerY.equalTo(self.nameTextField.snp.centerY)
            make.leading.equalTo(self.nameTextField.snp.trailing).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
        })

        self.nameUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.nameTextField.snp.bottom)
        })

        self.nameStatusLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.nameUnderlineLabel.snp.bottom).offset(8)
        })

        self.hostNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.nameStatusLabel.snp.bottom).offset(40)
        })

        self.hostNameTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.hostNameLabel.snp.bottom)
        })

        self.hostNameUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.hostNameTextField.snp.bottom)
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
        self.nameTextField.resignFirstResponder()
    }
    
    @objc private func saveButtonPressed() {
        let nameHasErrors = self.nameHasErrors()

        if nameHasErrors {
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

    private func nameHasErrors() -> Bool {
        let name = self.nameTextField.text!

        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            self.nameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.nameStatusLabel.text = "Required"
            self.nameStatusLabel.isHidden = false
            return true
        } else {
            self.nameUnderlineLabel.backgroundColor = Partybox.colors.black
            self.nameStatusLabel.text = " "
            self.nameStatusLabel.isHidden = true
            return false
        }
    }

    func name() -> String {
        return self.nameTextField.text!
    }

    func setHostName(_ hostName: String) {
        self.hostNameTextField.text = hostName
    }

    func hostName() -> String {
        return self.hostNameTextField.text!
    }

}

extension ManagePartyView: UITextFieldDelegate {

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.hostNameTextField {
            self.delegate.managePartyView(self, hostNameTextFieldPressed: true)
            return false
        }

        return true
    }

    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterCount = textField.text!.count + string.count - range.length

        if textField == self.nameTextField && characterCount <= self.nameMaxCharacterCount {
            self.nameCharacterCountLabel.text = "\(self.nameMaxCharacterCount - characterCount)"
            return true
        }

        return false
    }

    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            self.nameCharacterCountLabel.text = "\(self.nameMaxCharacterCount)"
        }

        return true
    }

}
