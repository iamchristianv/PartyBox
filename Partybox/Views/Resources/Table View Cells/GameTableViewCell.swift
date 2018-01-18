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
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = Party.game.details.name
        nameLabel.font = UIFont.avenirNextRegular(size: 26)
        nameLabel.textColor = UIColor.Partybox.black
        return nameLabel
    }()
    
    var summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.text = Party.game.details.summary
        summaryLabel.font = UIFont.avenirNextRegular(size: 14)
        summaryLabel.textColor = UIColor.Partybox.black
        summaryLabel.numberOfLines = 0
        return summaryLabel
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
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.summaryLabel)

        self.nameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.summaryLabel.snp.top).offset(-8)
        })
        
        self.summaryLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
    }

}
