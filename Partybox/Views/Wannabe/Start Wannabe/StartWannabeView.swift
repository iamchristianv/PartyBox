//
//  StartWannabeView.swift
//  Partybox
//
//  Created by Christian Villa on 6/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class StartWannabeView: UIView {

    // MARK: - Instance Properties

    private lazy var gameNameLabel: UILabel = {
        let gameNameLabel = UILabel()
        gameNameLabel.text = self.dataSource.startWannabeViewGameName()
        gameNameLabel.font = Partybox.font.avenirNextRegular(size: 28)
        gameNameLabel.textColor = Partybox.color.black
        gameNameLabel.textAlignment = .center
        return gameNameLabel
    }()

    private lazy var gameInstructionsLabel: UILabel = {
        let gameInstructionsLabel = UILabel()
        gameInstructionsLabel.text = self.dataSource.startWannabeViewGameInstructions()
        gameInstructionsLabel.font = Partybox.font.avenirNextRegular(size: 20)
        gameInstructionsLabel.textColor = Partybox.color.black
        gameInstructionsLabel.textAlignment = .center
        gameInstructionsLabel.numberOfLines = 0
        return gameInstructionsLabel
    }()

    private lazy var waitingLabel: UILabel = {
        let waitingLabel = UILabel()
        waitingLabel.text = "Waiting for Everyone to be Ready"
        waitingLabel.font = Partybox.font.avenirNextRegular(size: 18)
        waitingLabel.textColor = Partybox.color.black
        waitingLabel.textAlignment = .center
        waitingLabel.isHidden = true
        return waitingLabel
    }()

    private lazy var readyButton: ActivityIndicatorButton = {
        let readyButton = ActivityIndicatorButton()
        readyButton.setTitle("Ready", for: .normal)
        readyButton.setTitleFont(Partybox.font.avenirNextMediumName, size: 22)
        readyButton.setTitleColor(Partybox.color.white, for: .normal)
        readyButton.setBackgroundColor(Partybox.color.green)
        readyButton.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        return readyButton
    }()

    private var delegate: StartWannabeViewDelegate!

    private var dataSource: StartWannabeViewDataSource!

    // MARK: - Construction Functions

    static func construct(delegate: StartWannabeViewDelegate, dataSource: StartWannabeViewDataSource) -> StartWannabeView {
        let view = StartWannabeView()
        view.delegate = delegate
        view.dataSource = dataSource
        view.setupView()
        return view
    }

    // MARK: - Setup Functions

    private func setupView() {
        self.backgroundColor = .white

        self.addSubview(self.gameNameLabel)
        self.addSubview(self.gameInstructionsLabel)
        self.addSubview(self.waitingLabel)
        self.addSubview(self.readyButton)

        self.gameNameLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.snp.top).offset(32)
        })

        self.gameInstructionsLabel.snp.remakeConstraints({
            (make) in

            make.height.equalTo(100)
            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.top.equalTo(self.gameNameLabel.snp.bottom).offset(10)
        })

        self.waitingLabel.snp.remakeConstraints({
            (make) in

            make.leading.equalTo(self.snp.leading).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.bottom.equalTo(self.readyButton.snp.top).offset(-40)
        })

        self.readyButton.snp.remakeConstraints({
            (make) in

            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }

    // MARK: - Action Functions

    @objc private func readyButtonPressed() {
        self.waitingLabel.isHidden = false
        self.delegate.startWannabeView(self, readyButtonPressed: true)
    }

    // MARK: - Animation Functions

    func startAnimatingReadyButton() {
        self.readyButton.startAnimating()
    }

    func stopAnimatingReadyButton() {
        self.readyButton.stopAnimating()
    }

}
