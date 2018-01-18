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
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "INVITE CODE"
        titleLabel.textColor = UIColor.Partybox.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.avenirNextRegular(size: 14)
        return titleLabel
    }()
    
    lazy var inviteCodeLabel: UILabel = {
        let inviteCodeLabel = UILabel()
        inviteCodeLabel.textColor = UIColor.Partybox.black
        inviteCodeLabel.textAlignment = .center
        inviteCodeLabel.font = UIFont.avenirNextRegular(size: 26)
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
        self.addSubview(self.titleLabel)
        self.addSubview(self.inviteCodeLabel)
        
        self.titleLabel.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(16)
        })
        
        self.inviteCodeLabel.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.titleLabel.snp.bottom)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        })
    }
    
    // MARK: - Setter Methods
    
    func setInviteCode(_ inviteCode: String) {
        self.inviteCodeLabel.text = inviteCode
    }

}
