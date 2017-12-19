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
        containerView.addSubview(self.alertLabel)
        containerView.addSubview(self.messageLabel)
        containerView.addSubview(self.actionButton)
        return containerView
    }()
    
    lazy var alertLabel: UILabel = {
        let alertLabel = UILabel()
        alertLabel.text = self.alert
        alertLabel.textColor = .black
        alertLabel.font = UIFont.avenirNextRegular(size: 24)
        alertLabel.numberOfLines = 0
        alertLabel.textAlignment = .center
        return alertLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = self.message
        messageLabel.textColor = .black
        messageLabel.font = UIFont.avenirNextRegular(size: 18)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }()
    
    lazy var actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.setTitle(self.action, for: .normal)
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.setTitleFont(UIFont.avenirNextRegularName, size: 18)
        return actionButton
    }()
    
    var alert: String
    
    var message: String
    
    var action: String
    
    // MARK: - Initialization Methods
    
    init(alert: String, message: String, action: String) {
        self.alert = alert
        self.message = message
        self.action = action
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.25)
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
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
        
        self.containerView.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.center.equalTo(self.snp.center)
        })
        
        self.alertLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.containerView.snp.leading).offset(24)
            make.top.equalTo(self.containerView.snp.top).offset(24)
            make.trailing.equalTo(self.containerView.snp.trailing).offset(-24)
            make.bottom.equalTo(self.messageLabel.snp.top).offset(-8)
        })
        
        self.messageLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.containerView.snp.leading).offset(24)
            make.top.equalTo(self.alertLabel.snp.bottom).offset(8)
            make.trailing.equalTo(self.containerView.snp.trailing).offset(-24)
            make.bottom.equalTo(self.actionButton.snp.top).offset(-24)
        })
        
        self.actionButton.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.containerView.snp.centerX)
            make.top.equalTo(self.messageLabel.snp.bottom).offset(24)
            make.bottom.equalTo(self.containerView.snp.bottom).offset(-24)
        })
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(color: UIColor) {
        
    }
    
}
