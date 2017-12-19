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
    
    var timer: Timer!
    
    var minutes: Int = 0
    
    var seconds: Int = 0
    
    var delegate: GameCountdownTableViewCellDelegate!
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setBackgroundColor(.white)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func startCountdown() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(updateCountdown),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc func updateCountdown() {
        self.seconds -= 1
        
        let minutesRemaining = self.seconds / 60
        let secondsRemaining = self.seconds % 60
        self.countdownLabel.text = String(format: "%02d", minutesRemaining) + ":" + String(format: "%02d", secondsRemaining)
        
        if self.seconds == 0 {
            self.endCountdown()
        }
    }
    
    func endCountdown() {
        self.timer.invalidate()
        self.delegate.gameCountdownTableViewCell(self, countdownEnded: self.minutes)
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setPrompt(_ prompt: String) {
        self.promptLabel.text = prompt
    }
    
    func setMinutes(_ minutes: Int) {
        self.minutes = minutes
        self.seconds = minutes * 60
        
        self.countdownLabel.text = String(format: "%02d", minutes) + ":00"
        
        self.startCountdown()
    }

}
