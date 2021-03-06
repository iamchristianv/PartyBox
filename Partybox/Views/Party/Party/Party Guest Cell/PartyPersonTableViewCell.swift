//
//  PartyGuestTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyGuestTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: PartyGuestTableViewCell.self)
    
    // MARK: - Instance Properties
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = Partybox.font.avenirNextRegular(size: 18)
        nameLabel.textColor = Partybox.color.black
        return nameLabel
    }()
    
    private lazy var flairLabel: UILabel = {
        let flairLabel = UILabel()
        flairLabel.font = Partybox.font.avenirNextMedium(size: 14)
        flairLabel.textColor = Partybox.color.black
        return flairLabel
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = Partybox.font.avenirNextRegular(size: 18)
        emojiLabel.textColor = Partybox.color.black
        return emojiLabel
    }()
    
    private lazy var pointsLabel: UILabel = {
        let pointsLabel = UILabel()
        pointsLabel.font = Partybox.font.avenirNextRegular(size: 18)
        pointsLabel.textColor = Partybox.color.black
        return pointsLabel
    }()
    
    private lazy var underlineLabel: UILabel = {
        let underlineLabel = UILabel()
        underlineLabel.backgroundColor = Partybox.color.lightGray
        return underlineLabel
    }()

    // MARK: - Configuration Functions

    func configure(name: String, isMe: Bool, isHost: Bool, emoji: String, points: Int) {
        self.nameLabel.text = name

        if isMe && isHost {
            self.flairLabel.text = "ME / HOST"
        } else if isMe {
            self.flairLabel.text = "ME"
        } else if isHost {
            self.flairLabel.text = "HOST"
        }

        self.emojiLabel.text = emoji
        self.pointsLabel.text = "\(points) pts"
        self.setupView()
    }
    
    // MARK: - View Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flairLabel.text = ""
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = Partybox.color.white
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none

        self.addSubview(self.nameLabel)
        self.addSubview(self.flairLabel)
        self.addSubview(self.emojiLabel)
        self.addSubview(self.pointsLabel)
        self.addSubview(self.underlineLabel)
        
        self.nameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.flairLabel.snp.remakeConstraints({
            (make) in
            
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.trailing.equalTo(self.emojiLabel.snp.leading).offset(-8)
        })
        
        self.emojiLabel.snp.remakeConstraints({
            (make) in
            
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.trailing.equalTo(self.pointsLabel.snp.leading).offset(-8)
        })
        
        self.pointsLabel.snp.remakeConstraints({
            (make) in
            
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
        })
        
        self.underlineLabel.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(0.5)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
    }

}
