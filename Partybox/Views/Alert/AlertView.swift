//
//  AlertView.swift
//  Partybox
//
//  Created by Christian Villa on 11/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class AlertView: UIView {

    // MARK: - Instance Properties
    
    lazy var backgroundButton: UIButton = {
        let backgroundButton = UIButton()
        return backgroundButton
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15.0
        containerView.addSubview(self.subjectLabel)
        containerView.addSubview(self.messageLabel)
        containerView.addSubview(self.actionButton)
        return containerView
    }()
    
    lazy var subjectLabel: UILabel = {
        let subjectLabel = UILabel()
        subjectLabel.text = self.subject
        subjectLabel.textColor = UIColor.Partybox.black
        subjectLabel.font = UIFont.avenirNextMedium(size: 20)
        subjectLabel.numberOfLines = 0
        subjectLabel.textAlignment = .center
        return subjectLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = self.message
        messageLabel.textColor = UIColor.Partybox.black
        messageLabel.font = UIFont.avenirNextRegular(size: 18)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    lazy var actionButton: ActivityButton = {
        let actionButton = ActivityButton()
        actionButton.setTitle(self.action, for: .normal)
        actionButton.setTitleFont(UIFont.avenirNextMediumName, size: 20)
        actionButton.setBackgroundColor(UIColor.Partybox.red)
        return actionButton
    }()
    
    var subject: String
    
    var message: String
    
    var action: String
    
    // MARK: - Initialization Methods
    
    init(subject: String, message: String, action: String) {
        self.subject = subject
        self.message = message
        self.action = action
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.backgroundButton)
        self.addSubview(self.containerView)
        
        self.backgroundButton.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        self.containerView.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.center.equalTo(self.snp.center)
        })
        
        self.subjectLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.containerView.snp.leading).offset(24)
            make.trailing.equalTo(self.containerView.snp.trailing).offset(-24)
            make.top.equalTo(self.containerView.snp.top).offset(24)
        })
        
        self.messageLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.containerView.snp.leading).offset(24)
            make.trailing.equalTo(self.containerView.snp.trailing).offset(-24)
            make.top.equalTo(self.subjectLabel.snp.bottom).offset(16)
        })
        
        self.actionButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalTo(self.containerView.snp.centerX)
            make.top.equalTo(self.messageLabel.snp.bottom).offset(24)
            make.bottom.equalTo(self.containerView.snp.bottom).offset(-24)
        })
    }
    
}
