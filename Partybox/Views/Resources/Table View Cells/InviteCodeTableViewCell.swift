//
//  InviteCodeTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 1/16/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class InviteCodeTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: InviteCodeTableViewCell.self)
    
    // MARK: - Instance Properties
    
    lazy var inviteCodeTitleLabel: UILabel = {
        let inviteCodeTitleLabel = UILabel()
        inviteCodeTitleLabel.text = "INVITE CODE"
        inviteCodeTitleLabel.font = UIFont.avenirNextRegular(size: 14)
        inviteCodeTitleLabel.textColor = UIColor.Partybox.black
        inviteCodeTitleLabel.textAlignment = .center
        return inviteCodeTitleLabel
    }()
    
    lazy var inviteCodeLabel: UILabel = {
        let inviteCodeLabel = UILabel()
        inviteCodeLabel.text = Party.inviteCode
        inviteCodeLabel.font = UIFont.avenirNextRegular(size: 24)
        inviteCodeLabel.textColor = UIColor.Partybox.black
        inviteCodeLabel.textAlignment = .center
        return inviteCodeLabel
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
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.inviteCodeTitleLabel)
        self.addSubview(self.inviteCodeLabel)
        
        self.inviteCodeTitleLabel.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(16)
        })
        
        self.inviteCodeLabel.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.inviteCodeTitleLabel.snp.bottom)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        })
    }

}
