//
//  HeaderTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: HeaderTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.textColor = .black
        headerLabel.font = UIFont.avenirNextRegular(size: 12)
        return headerLabel
    }()
    
    var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.textColor = .black
        emojiLabel.font = UIFont.avenirNextRegular(size: 14)
        return emojiLabel
    }()
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = false
        self.setBackgroundColor(.white)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.headerLabel)
        self.addSubview(self.emojiLabel)
        
        self.headerLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.emojiLabel.snp.remakeConstraints({
            (make) in
            
            make.top.equalTo(self.snp.top).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setHeader(_ header: String) {
        self.headerLabel.text = header
    }
    
    func setEmoji(_ emoji: String) {
        self.emojiLabel.text = emoji
    }

}
