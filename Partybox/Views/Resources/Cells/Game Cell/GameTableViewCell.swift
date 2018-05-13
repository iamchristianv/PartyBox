//
//  GameTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: GameTableViewCell.self)
    
    // MARK: - Instance Properties

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.Partybox.avenirNextMedium(size: 26)
        nameLabel.textColor = UIColor.Partybox.black
        return nameLabel
    }()
    
    private lazy var summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.font = UIFont.Partybox.avenirNextRegular(size: 16)
        summaryLabel.textColor = UIColor.Partybox.black
        summaryLabel.numberOfLines = 0
        return summaryLabel
    }()

    lazy var playGameButton: ActivityIndicatorButton = {
        let playGameButton = ActivityIndicatorButton()
        playGameButton.setTitle("Play Game", for: .normal)
        playGameButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        playGameButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        playGameButton.setBackgroundColor(UIColor.Partybox.green)
        playGameButton.addTarget(self, action: #selector(playGameButtonPressed), for: .touchUpInside)
        return playGameButton
    }()

    lazy var changeGameButton: ActivityIndicatorButton = {
        let changeGameButton = ActivityIndicatorButton()
        changeGameButton.setTitle("Change Game", for: .normal)
        changeGameButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        changeGameButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        changeGameButton.setBackgroundColor(UIColor.Partybox.green)
        changeGameButton.addTarget(self, action: #selector(changeGameButtonPressed), for: .touchUpInside)
        return changeGameButton
    }()

    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.addSubview(self.activityIndicator)
        containerView.addSubview(self.promptLabel)
        return containerView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private lazy var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.text = "Waiting for Host to Start Game"
        promptLabel.font = UIFont.Partybox.avenirNextRegular(size: 18)
        promptLabel.textColor = UIColor.Partybox.black
        return promptLabel
    }()

    private var isHostEnabled: Bool = false

    private var delegate: GameTableViewCellDelegate!

    // MARK: - Configuration Functions

    func configure(name: String, summary: String, isHostEnabled: Bool, delegate: GameTableViewCellDelegate) {
        self.nameLabel.text = name
        self.summaryLabel.text = summary
        self.isHostEnabled = isHostEnabled
        self.delegate = delegate
        self.setupView()
    }

    // MARK: - View Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.startAnimating()
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = UIColor.Partybox.white
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none

        self.addSubview(self.nameLabel)
        self.addSubview(self.summaryLabel)

        self.nameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.snp.top).offset(16)
        })
        
        self.summaryLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
        })

        if self.isHostEnabled {
            self.containerView.removeFromSuperview()

            self.addSubview(self.playGameButton)
            self.addSubview(self.changeGameButton)

            self.playGameButton.snp.remakeConstraints({
                (make) in

                make.width.equalTo(220)
                make.height.equalTo(55)
                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(self.summaryLabel.snp.bottom).offset(24)
            })

            self.changeGameButton.snp.remakeConstraints({
                (make) in

                make.width.equalTo(220)
                make.height.equalTo(55)
                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(self.playGameButton.snp.bottom).offset(24)
                make.bottom.equalTo(self.snp.bottom).offset(-24)
            })
        } else {
            self.playGameButton.removeFromSuperview()
            self.changeGameButton.removeFromSuperview()

            self.addSubview(self.containerView)

            self.containerView.snp.remakeConstraints({
                (make) in

                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(self.summaryLabel.snp.bottom).offset(24)
                make.bottom.equalTo(self.snp.bottom).offset(-24)
            })

            self.activityIndicator.snp.remakeConstraints({
                (make) in

                make.leading.equalTo(self.containerView.snp.leading)
                make.trailing.equalTo(self.promptLabel.snp.leading).offset(-8)
                make.top.equalTo(self.containerView.snp.top)
                make.bottom.equalTo(self.containerView.snp.bottom)
            })

            self.promptLabel.snp.remakeConstraints({
                (make) in

                make.leading.equalTo(self.activityIndicator.snp.trailing).offset(8)
                make.trailing.equalTo(self.containerView.snp.trailing)
                make.top.equalTo(self.containerView.snp.top)
                make.bottom.equalTo(self.containerView.snp.bottom)
            })
        }
    }

    // MARK: - Action Functions

    @objc private func playGameButtonPressed() {
        self.delegate.gameTableViewCell(self, playGameButtonPressed: true)
    }

    @objc private func changeGameButtonPressed() {
        self.delegate.gameTableViewCell(self, changeGameButtonPressed: true)
    }

}
