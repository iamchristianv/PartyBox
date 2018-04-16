//
//  GameCountdownTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class GameCountdownTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: GameCountdownTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.font = UIFont.avenirNextRegular(size: 12)
        promptLabel.textColor = .black
        promptLabel.textAlignment = .center
        return promptLabel
    }()
    
    var countdownLabel: UILabel = {
        let countdownLabel = UILabel()
        countdownLabel.text = "00:00"
        countdownLabel.font = UIFont.avenirNextRegular(size: 40)
        countdownLabel.textColor = .black
        countdownLabel.textAlignment = .center
        return countdownLabel
    }()
    
    // MARK: - Initialization Functions
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupView() {
        self.selectionStyle = .none
    }
    
    func setupSubviews() {
        self.addSubview(self.promptLabel)
        self.addSubview(self.countdownLabel)
        
        self.promptLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
            make.bottom.equalTo(self.countdownLabel.snp.top).offset(-16)
        })
        
        self.countdownLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(32)
            make.top.equalTo(self.promptLabel.snp.bottom).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-32)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
        })
    }
    
    // MARK: - Setter Methods
    
    func setPrompt(_ prompt: String) {
        self.promptLabel.text = prompt
    }
    
    func setCountdown() {
        let minutesRemaining = Countdown.current.seconds / 60
        let secondsRemaining = Countdown.current.seconds % 60
        
        self.countdownLabel.text = String(format: "%02d", minutesRemaining) + ":" + String(format: "%02d", secondsRemaining)
    }

}
