//
//  PromptTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/6/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PromptTableViewCell: UITableViewCell {
    
    // MARK: - Class Properties
    
    static let name: String = String(describing: PromptTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.textColor = .black
        promptLabel.font = Font.avenirNextRegular(size: 18)
        return promptLabel
    }()

    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.promptLabel)
        
        self.promptLabel.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
    }
    
}
