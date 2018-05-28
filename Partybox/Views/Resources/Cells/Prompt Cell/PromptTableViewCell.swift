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
    
    private var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.font = Partybox.fonts.avenirNextRegular(size: 16)
        promptLabel.textColor = Partybox.colors.black
        promptLabel.textAlignment = .center
        promptLabel.numberOfLines = 0
        return promptLabel
    }()

    // MARK: - Configuration Functions

    func configure(prompt: String) {
        self.promptLabel.text = prompt
        self.setupView()
    }
    
    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = Partybox.colors.white
        self.isUserInteractionEnabled = false
        self.selectionStyle = .none

        self.addSubview(self.promptLabel)
        
        self.promptLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
    }
    
}
