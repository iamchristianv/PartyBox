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
    
    private lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = Partybox.font.avenirNextMedium(size: 14)
        headerLabel.textColor = Partybox.color.white
        return headerLabel
    }()

    // MARK: - Configuration Functions

    func configure(header: String) {
        self.headerLabel.text = header
        self.setupView()
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = Partybox.color.green
        self.isUserInteractionEnabled = false
        self.selectionStyle = .none

        self.addSubview(self.headerLabel)
        
        self.headerLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        })
    }

}
