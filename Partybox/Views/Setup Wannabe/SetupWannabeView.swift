//
//  SetupWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 5/29/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SetupWannabeView: UIView {

    // MARK: - Instance Properties

    private lazy var roundsLabel: UILabel = {
        let roundsLabel = UILabel()
        roundsLabel.text = "Rounds"
        roundsLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        roundsLabel.textColor = Partybox.colors.black
        return roundsLabel
    }()

    private lazy var roundsTextField: UITextField = {
        let roundsTextField = UITextField()
        roundsTextField.delegate = self
        roundsTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        roundsTextField.textColor = Partybox.colors.black
        roundsTextField.borderStyle = .none
        return roundsTextField
    }()

    private lazy var roundsUnderlineLabel: UILabel = {
        let roundsUnderlineLabel = UILabel()
        roundsUnderlineLabel.backgroundColor = Partybox.colors.black
        return roundsUnderlineLabel
    }()

    private lazy var roundsStatusLabel: UILabel = {
        let roundsStatusLabel = UILabel()
        roundsStatusLabel.text = " "
        roundsStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        roundsStatusLabel.textColor = Partybox.colors.red
        roundsStatusLabel.isHidden = true
        return roundsStatusLabel
    }()

    private lazy var packNameLabel: UILabel = {
        let packNameLabel = UILabel()
        packNameLabel.text = "Pack"
        packNameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        packNameLabel.textColor = Partybox.colors.black
        return packNameLabel
    }()

    private lazy var packNameTextField: UITextField = {
        let packNameTextField = UITextField()
        packNameTextField.delegate = self
        packNameTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        packNameTextField.textColor = Partybox.colors.black
        packNameTextField.borderStyle = .none
        return packNameTextField
    }()

    private lazy var packNameUnderlineLabel: UILabel = {
        let packNameUnderlineLabel = UILabel()
        packNameUnderlineLabel.backgroundColor = Partybox.colors.black
        return packNameUnderlineLabel
    }()

    private lazy var packNameStatusLabel: UILabel = {
        let packNameStatusLabel = UILabel()
        packNameStatusLabel.text = " "
        packNameStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        packNameStatusLabel.textColor = Partybox.colors.red
        packNameStatusLabel.isHidden = true
        return packNameStatusLabel
    }()

    private lazy var startButton: ActivityIndicatorButton = {
        let startButton = ActivityIndicatorButton()
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        startButton.setTitleColor(Partybox.colors.white, for: .normal)
        startButton.setBackgroundColor(Partybox.colors.green)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return startButton
    }()

    private var selectedPackId: String = Partybox.values.none

    private var delegate: SetupWannabeViewDelegate!

    // MARK: - Construction Functions

    static func construct(delegate: SetupWannabeViewDelegate) -> SetupWannabeView {
        let view = SetupWannabeView()
        view.selectedPackId = Partybox.values.none
        view.delegate = delegate
        view.setupView()
        return view
    }

    // MARK: - Setup Functions

    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.roundsLabel)
        self.addSubview(self.roundsTextField)
        self.addSubview(self.roundsUnderlineLabel)
        self.addSubview(self.roundsStatusLabel)
        self.addSubview(self.packNameLabel)
        self.addSubview(self.packNameTextField)
        self.addSubview(self.packNameUnderlineLabel)
        self.addSubview(self.packNameStatusLabel)
        self.addSubview(self.startButton)

        self.roundsLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })

        self.roundsTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsLabel.snp.bottom)
        })

        self.roundsUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsTextField.snp.bottom)
        })

        self.roundsStatusLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsUnderlineLabel.snp.bottom).offset(8)
        })

        self.packNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsStatusLabel.snp.bottom).offset(40)
        })

        self.packNameTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.packNameLabel.snp.bottom)
        })

        self.packNameUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.packNameTextField.snp.bottom)
        })

        self.packNameStatusLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.packNameUnderlineLabel.snp.bottom).offset(8)
        })

        self.startButton.snp.remakeConstraints({
            (make) in

            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }

    // MARK: - Action Functions

    @objc private func startButtonPressed() {
        let roundsHasErrors = self.roundsHasErrors()
        let packNameHasErrors = self.packNameHasErrors()

        if roundsHasErrors || packNameHasErrors {
            return
        }

        self.delegate.setupWannabeView(self, startButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingStartButton() {
        self.startButton.startAnimating()
    }

    func stopAnimatingStartButton() {
        self.startButton.stopAnimating()
    }

    // MARK: - View Functions

    private func roundsHasErrors() -> Bool {
        let rounds = self.roundsTextField.text!

        if rounds.trimmingCharacters(in: .whitespaces).isEmpty {
            self.roundsUnderlineLabel.backgroundColor = Partybox.colors.red
            self.roundsStatusLabel.text = "Required"
            self.roundsStatusLabel.isHidden = false
            return true
        } else {
            self.roundsUnderlineLabel.backgroundColor = Partybox.colors.black
            self.roundsStatusLabel.text = " "
            self.roundsStatusLabel.isHidden = true
            return false
        }
    }

    func setRounds(_ rounds: String) {
        self.roundsTextField.text = rounds
    }

    func rounds() -> String {
        return self.roundsTextField.text!
    }

    func setPackId(_ packId: String) {
        self.selectedPackId = packId
    }

    func packId() -> String {
        return self.selectedPackId
    }

    private func packNameHasErrors() -> Bool {
        let packName = self.packNameTextField.text!

        if packName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.packNameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.packNameStatusLabel.text = "Required"
            self.packNameStatusLabel.isHidden = false
            return true
        } else {
            self.packNameUnderlineLabel.backgroundColor = Partybox.colors.black
            self.packNameStatusLabel.text = " "
            self.packNameStatusLabel.isHidden = true
            return false
        }
    }

    func setPackName(_ packName: String) {
        self.packNameTextField.text = packName
    }

    func packName() -> String {
        return self.packNameTextField.text!
    }

}

extension SetupWannabeView: UITextFieldDelegate {

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.roundsTextField {
            self.delegate.setupWannabeView(self, roundsTextFieldPressed: true)
            return false
        } else if textField == self.packNameTextField {
            self.delegate.setupWannabeView(self, packNameTextFieldPressed: true)
            return false
        }

        return true
    }

}
