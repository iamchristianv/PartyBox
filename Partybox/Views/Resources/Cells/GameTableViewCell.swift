//
//  GameTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol GameTableViewCellDelegate {

    // MARK: - Game Table View Cell Functions

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, playButtonPressed: Bool)

    func gameTableViewCell(_ gameTableViewCell: GameTableViewCell, changeButtonPressed: Bool)

}

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

    private lazy var playButton: ActivityIndicatorButton = {
        let playButton = ActivityIndicatorButton()
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        playButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        playButton.setBackgroundColor(UIColor.Partybox.green)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return playButton
    }()

    private lazy var changeButton: ActivityIndicatorButton = {
        let changeButton = ActivityIndicatorButton()
        changeButton.setTitle("Change", for: .normal)
        changeButton.setTitleFont(UIFont.Partybox.avenirNextMediumName, size: 22)
        changeButton.setTitleColor(UIColor.Partybox.white, for: .normal)
        changeButton.setBackgroundColor(UIColor.Partybox.green)
        changeButton.addTarget(self, action: #selector(changeButtonPressed), for: .touchUpInside)
        return changeButton
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

    private var isEnabledForHost: Bool = false

    var delegate: GameTableViewCellDelegate!

    // MARK: - View Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.startAnimating()
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
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

        if self.isEnabledForHost {
            self.containerView.removeFromSuperview()

            self.addSubview(self.playButton)
            self.addSubview(self.changeButton)

            self.playButton.snp.remakeConstraints({
                (make) in

                make.width.equalTo(220)
                make.height.equalTo(55)
                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(self.summaryLabel.snp.bottom).offset(24)
            })

            self.changeButton.snp.remakeConstraints({
                (make) in

                make.width.equalTo(220)
                make.height.equalTo(55)
                make.centerX.equalTo(self.snp.centerX)
                make.top.equalTo(self.playButton.snp.bottom).offset(24)
                make.bottom.equalTo(self.snp.bottom).offset(-24)
            })
        } else {
            self.playButton.removeFromSuperview()
            self.changeButton.removeFromSuperview()

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

    @objc private func playButtonPressed() {
        self.delegate.gameTableViewCell(self, playButtonPressed: true)
    }

    @objc private func changeButtonPressed() {
        self.delegate.gameTableViewCell(self, changeButtonPressed: true)
    }
    
    // MARK: - Setter Functions
    
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
    
    func setSummary(_ summary: String) {
        self.summaryLabel.text = summary
    }

    func setIsEnabledForHost(_ isEnabledForHost: Bool) {
        self.isEnabledForHost = isEnabledForHost
    }

}
