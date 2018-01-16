//
//  PartyPersonTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyPersonTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: PartyPersonTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.Partybox.black
        nameLabel.font = UIFont.avenirNextRegular(size: 16)
        return nameLabel
    }()
    
    var flairLabel: UILabel = {
        let flairLabel = UILabel()
        flairLabel.textColor = UIColor.Partybox.black
        flairLabel.font = UIFont.avenirNextMedium(size: 12)
        return flairLabel
    }()
    
    var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.avenirNextRegular(size: 16)
        return emojiLabel
    }()
    
    var pointsLabel: UILabel = {
        let pointsLabel = UILabel()
        pointsLabel.textColor = UIColor.Partybox.black
        pointsLabel.font = UIFont.avenirNextRegular(size: 16)
        return pointsLabel
    }()
    
    var underlineLabel: UILabel = {
        let underlineLabel = UILabel()
        underlineLabel.backgroundColor = UIColor.lightGray
        return underlineLabel
    }()
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flairLabel.text = ""
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.flairLabel)
        self.addSubview(self.emojiLabel)
        self.addSubview(self.pointsLabel)
        self.addSubview(self.underlineLabel)
        
        self.nameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.flairLabel.snp.leading).offset(-8)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.flairLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(8)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.emojiLabel.snp.remakeConstraints({
            (make) in
            
            make.trailing.equalTo(self.pointsLabel.snp.leading).offset(-8)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.pointsLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.emojiLabel.snp.trailing).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.underlineLabel.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(0.5)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
    
    // MARK: - Setter Methods
    
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
    
    func setFlair(_ name: String) {
        if name == Party.userName && name == Party.details.host {
            self.flairLabel.text = "ME / HOST"
        }
        else if name == Party.userName {
            self.flairLabel.text = "ME"
        }
        else if name == Party.details.host {
            self.flairLabel.text = "HOST"
        }
    }
    
    func setEmoji(_ emoji: String) {
        self.emojiLabel.text = emoji
    }
    
    func setPoints(_ points: Int) {
        self.pointsLabel.text = "\(points) pts"
    }

}
