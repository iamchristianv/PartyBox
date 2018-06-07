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

    private lazy var roundsNameLabel: UILabel = {
        let roundsNameLabel = UILabel()
        roundsNameLabel.text = "Duration"
        roundsNameLabel.font = Partybox.fonts.avenirNextRegular(size: 20)
        roundsNameLabel.textColor = Partybox.colors.black
        return roundsNameLabel
    }()

    private lazy var roundsNameTextField: UITextField = {
        let roundsNameTextField = UITextField()
        roundsNameTextField.delegate = self
        roundsNameTextField.font = Partybox.fonts.avenirNextRegular(size: 28)
        roundsNameTextField.textColor = Partybox.colors.black
        roundsNameTextField.borderStyle = .none
        return roundsNameTextField
    }()

    private lazy var roundsNameUnderlineLabel: UILabel = {
        let roundsNameUnderlineLabel = UILabel()
        roundsNameUnderlineLabel.backgroundColor = Partybox.colors.black
        return roundsNameUnderlineLabel
    }()

    private lazy var roundsNameStatusLabel: UILabel = {
        let roundsNameStatusLabel = UILabel()
        roundsNameStatusLabel.text = " "
        roundsNameStatusLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        roundsNameStatusLabel.textColor = Partybox.colors.red
        roundsNameStatusLabel.isHidden = true
        return roundsNameStatusLabel
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

    private lazy var playButton: ActivityIndicatorButton = {
        let playButton = ActivityIndicatorButton()
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleFont(Partybox.fonts.avenirNextMediumName, size: 22)
        playButton.setTitleColor(Partybox.colors.white, for: .normal)
        playButton.setBackgroundColor(Partybox.colors.green)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return playButton
    }()

    var roundsName: String! {
        willSet {
            self.roundsNameTextField.text = newValue
        }
    }

    var packName: String! {
        willSet {
            self.packNameTextField.text = newValue
        }
    }

    private var delegate: SetupWannabeViewDelegate!

    // MARK: - Construction Functions

    static func construct(delegate: SetupWannabeViewDelegate) -> SetupWannabeView {
        let view = SetupWannabeView()
        view.delegate = delegate
        view.setupView()
        return view
    }

    // MARK: - Setup Functions

    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.roundsNameLabel)
        self.addSubview(self.roundsNameTextField)
        self.addSubview(self.roundsNameUnderlineLabel)
        self.addSubview(self.roundsNameStatusLabel)
        self.addSubview(self.packNameLabel)
        self.addSubview(self.packNameTextField)
        self.addSubview(self.packNameUnderlineLabel)
        self.addSubview(self.packNameStatusLabel)
        self.addSubview(self.playButton)

        self.roundsNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })

        self.roundsNameTextField.snp.remakeConstraints({
            (make) in

            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsNameLabel.snp.bottom)
        })

        self.roundsNameUnderlineLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(1)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsNameTextField.snp.bottom)
        })

        self.roundsNameStatusLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsNameUnderlineLabel.snp.bottom).offset(8)
        })

        self.packNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.roundsNameStatusLabel.snp.bottom).offset(40)
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

        self.playButton.snp.remakeConstraints({
            (make) in

            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }

    // MARK: - Action Functions

    @objc private func playButtonPressed() {
        let roundsNameHasErrors = self.roundsNameHasErrors()
        let packNameHasErrors = self.packNameHasErrors()

        if roundsNameHasErrors || packNameHasErrors {
            return
        }

        self.delegate.setupWannabeView(self, playButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingPlayButton() {
        self.playButton.startAnimating()
    }

    func stopAnimatingPlayButton() {
        self.playButton.stopAnimating()
    }

    // MARK: - View Functions

    private func roundsNameHasErrors() -> Bool {
        if self.roundsNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.roundsNameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.roundsNameStatusLabel.text = "Required"
            self.roundsNameStatusLabel.isHidden = false
            return true
        }

        self.roundsNameUnderlineLabel.backgroundColor = Partybox.colors.black
        self.roundsNameStatusLabel.text = " "
        self.roundsNameStatusLabel.isHidden = true
        return false
    }

    private func packNameHasErrors() -> Bool {
        if self.packNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.packNameUnderlineLabel.backgroundColor = Partybox.colors.red
            self.packNameStatusLabel.text = "Required"
            self.packNameStatusLabel.isHidden = false
            return true
        }

        self.packNameUnderlineLabel.backgroundColor = Partybox.colors.black
        self.packNameStatusLabel.text = " "
        self.packNameStatusLabel.isHidden = true
        return false
    }

}

extension SetupWannabeView: UITextFieldDelegate {

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.roundsNameTextField {
            self.delegate.setupWannabeView(self, roundsNameTextFieldPressed: true)
            return false
        }

        if textField == self.packNameTextField {
            self.delegate.setupWannabeView(self, packNameTextFieldPressed: true)
            return false
        }

        return true
    }

}
