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
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = Session.game.details.name
        nameLabel.textColor = .black
        nameLabel.font = UIFont.avenirNextRegular(size: 24)
        return nameLabel
    }()
    
    var summaryLabel: UILabel = {
        let summaryLabel = UILabel()
        summaryLabel.text = Session.game.details.summary
        summaryLabel.textColor = .black
        summaryLabel.font = UIFont.avenirNextRegular(size: 14)
        summaryLabel.numberOfLines = 0
        return summaryLabel
    }()
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setBackgroundColor(.white)
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
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }

}
