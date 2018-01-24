//
//  PersonTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: PersonTableViewCell.self)
    
    // MARK: - Instance Properties
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.avenirNextRegular(size: 18)
        nameLabel.textColor = UIColor.Partybox.black
        return nameLabel
    }()
    
    lazy var flairLabel: UILabel = {
        let flairLabel = UILabel()
        flairLabel.font = UIFont.avenirNextMedium(size: 14)
        flairLabel.textColor = UIColor.Partybox.black
        return flairLabel
    }()
    
    lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.avenirNextRegular(size: 18)
        emojiLabel.textColor = UIColor.Partybox.black
        return emojiLabel
    }()
    
    lazy var pointsLabel: UILabel = {
        let pointsLabel = UILabel()
        pointsLabel.font = UIFont.avenirNextRegular(size: 18)
        pointsLabel.textColor = UIColor.Partybox.black
        return pointsLabel
    }()
    
    lazy var underlineLabel: UILabel = {
        let underlineLabel = UILabel()
        underlineLabel.backgroundColor = UIColor.Partybox.lightGray
        return underlineLabel
    }()
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
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
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.flairLabel.snp.remakeConstraints({
            (make) in
            
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(12)
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
