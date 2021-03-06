//
//  PartyGameTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyGameTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: PartyGameTableViewCell.self)
    
    // MARK: - Instance Properties

    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Partybox.font.avenirNextMedium(size: 26)
        nameLabel.textColor = Partybox.color.black
        return nameLabel
    }()
    
    private lazy var summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.font = Partybox.font.avenirNextRegular(size: 16)
        summaryLabel.textColor = Partybox.color.black
        summaryLabel.numberOfLines = 0
        return summaryLabel
    }()

    lazy var playButton: ActivityIndicatorButton = {
        let playButton = ActivityIndicatorButton()
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleFont(Partybox.font.avenirNextMediumName, size: 22)
        playButton.setTitleColor(Partybox.color.white, for: .normal)
        playButton.setBackgroundColor(Partybox.color.green)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return playButton
    }()

    private lazy var changeButton: ActivityIndicatorButton = {
        let changeButton = ActivityIndicatorButton()
        changeButton.setTitle("Change", for: .normal)
        changeButton.setTitleFont(Partybox.font.avenirNextMediumName, size: 22)
        changeButton.setTitleColor(Partybox.color.white, for: .normal)
        changeButton.setBackgroundColor(Partybox.color.green)
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
        promptLabel.font = Partybox.font.avenirNextRegular(size: 18)
        promptLabel.textColor = Partybox.color.black
        return promptLabel
    }()

    private var hasHostActions: Bool = false

    private var delegate: PartyGameTableViewCellDelegate!

    // MARK: - Configuration Functions

    func configure(name: String, summary: String, hasHostActions: Bool, delegate: PartyGameTableViewCellDelegate) {
        self.nameLabel.text = name
        self.summaryLabel.text = summary
        self.hasHostActions = hasHostActions
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
        self.backgroundColor = Partybox.color.white
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

        if self.hasHostActions {
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
        self.delegate.partyGameTableViewCell(self, playButtonPressed: true)
    }

    @objc private func changeButtonPressed() {
        self.delegate.partyGameTableViewCell(self, changeButtonPressed: true)
    }

}
