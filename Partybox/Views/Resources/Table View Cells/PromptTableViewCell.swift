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
    
    static let identifier: String = String(describing: PromptTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.font = UIFont.avenirNextRegular(size: 16)
        promptLabel.textColor = UIColor.Partybox.black
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        return promptLabel
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
        self.addSubview(self.promptLabel)
        
        self.promptLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
    }
    
    // MARK: - Setter Methods
    
    func setPrompt(_ prompt: String) {
        self.promptLabel.text = prompt
    }
    
}
