//
//  GameCountdownTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 12/17/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol GameCountdownTableViewCellDelegate {
    
    func gameCountdownTableViewCell(_ gameCountdownTableViewCell: GameCountdownTableViewCell, countdownEnded minutes: Int)
    
}

class GameCountdownTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: GameCountdownTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.textColor = .black
        promptLabel.font = UIFont.avenirNextRegular(size: 12)
        promptLabel.textAlignment = .center
        return promptLabel
    }()
    
    var countdownLabel: UILabel = {
        let countdownLabel = UILabel()
        countdownLabel.textColor = .black
        countdownLabel.font = UIFont.avenirNextRegular(size: 40)
        countdownLabel.textAlignment = .center
        return countdownLabel
    }()
    
    var delegate: GameCountdownTableViewCellDelegate!
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configureSubviews()
        self.updateCountdownLabel()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(timerChangedNotificationObserved),
                                               name: Notification.Name(PartyNotification.timerChanged.rawValue),
                                               object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(PartyNotification.timerChanged.rawValue),
                                                  object: nil)
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
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
    
    // MARK: - Action Methods
    
    @objc func timerChangedNotificationObserved() {
        self.updateCountdownLabel()
        
        if Party.secondsRemaining == 0 {
            self.delegate.gameCountdownTableViewCell(self, countdownEnded: 0)
        }
    }
    
    func updateCountdownLabel() {
        let minutesRemaining = Party.secondsRemaining / 60
        let secondsRemaining = Party.secondsRemaining % 60
        
        self.countdownLabel.text = String(format: "%02d", minutesRemaining) + ":" + String(format: "%02d", secondsRemaining)
    }
    
    // MARK: - Setter Methods
    
    func setPrompt(_ prompt: String) {
        self.promptLabel.text = prompt
    }

}
