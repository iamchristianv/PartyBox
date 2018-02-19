//
//  GameInstructionsTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class GameInstructionsTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: GameInstructionsTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = UIFont.avenirNextRegular(size: 32)
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    var instructionsLabel: UILabel = {
        let instructionsLabel = UILabel()
        instructionsLabel.textColor = .black
        instructionsLabel.font = UIFont.avenirNextRegular(size: 18)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        return instructionsLabel
    }()
    
    // MARK: - Initialization Functions
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Functions
    
    func configureSubviews() {
        self.addSubview(self.nameLabel)
        self.addSubview(self.instructionsLabel)
        
        self.nameLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.instructionsLabel.snp.top).offset(-32)
        })
        
        self.instructionsLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(32)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.snp.bottom).offset(-32)
        })
    }
    
    // MARK: - Setter Functions
    
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
    
    func setInstructions(_ instructions: String) {
        self.instructionsLabel.text = instructions
    }

}
