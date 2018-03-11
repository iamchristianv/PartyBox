//
//  AlertView.swift
//  Partybox
//
//  Created by Christian Villa on 11/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol AlertViewDelegate {
    
    // MARK: - Alert View Delegate Functions
    
    func alertView(_ alertView: AlertView, actionButtonPressed: Bool)
    
    func alertView(_ alertView: AlertView, cancelButtonPressed: Bool)
    
}

class AlertView: UIView {

    // MARK: - Instance Properties
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15.0
        containerView.addSubview(self.subjectLabel)
        containerView.addSubview(self.messageLabel)
        containerView.addSubview(self.actionButton)
        containerView.addSubview(self.cancelButton)
        return containerView
    }()
    
    lazy var subjectLabel: UILabel = {
        let subjectLabel = UILabel()
        subjectLabel.text = self.alert.subject
        subjectLabel.font = UIFont.avenirNextMedium(size: 20)
        subjectLabel.textColor = UIColor.Partybox.black
        subjectLabel.textAlignment = .center
        subjectLabel.numberOfLines = 0
        return subjectLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = self.alert.message
        messageLabel.font = UIFont.avenirNextRegular(size: 18)
        messageLabel.textColor = UIColor.Partybox.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    lazy var actionButton: ActivityButton = {
        let actionButton = ActivityButton()
        actionButton.setTitle(self.alert.action, for: .normal)
        actionButton.setTitleFont(UIFont.avenirNextMediumName, size: 20)
        actionButton.setBackgroundColor(UIColor.Partybox.red)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return actionButton
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitleFont(UIFont.avenirNextRegularName, size: 18)
        cancelButton.setTitleColor(UIColor.Partybox.red, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return cancelButton
    }()
    
    var alert: Alert
    
    var delegate: AlertViewDelegate!
    
    // MARK: - Initialization Functions
    
    init(alert: Alert) {
        self.alert = alert
        super.init(frame: .zero)
        self.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
        self.addSubview(self.containerView)
        
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
            
            if self.alert.handler == nil {
                make.bottom.equalTo(self.containerView.snp.bottom).offset(-24)
            }
        })
        
        if self.alert.handler == nil {
            return
        }
        
        self.cancelButton.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.containerView.snp.centerX)
            make.top.equalTo(self.actionButton.snp.bottom).offset(12)
            make.bottom.equalTo(self.containerView.snp.bottom).offset(-12)
        })
    }
    
    // MARK: - Action Functions
    
    @objc func actionButtonPressed() {
        self.delegate.alertView(self, actionButtonPressed: true)
    }
    
    @objc func cancelButtonPressed() {
        self.delegate.alertView(self, cancelButtonPressed: true)
    }
    
}
