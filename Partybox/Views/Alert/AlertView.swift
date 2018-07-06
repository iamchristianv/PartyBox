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

protocol AlertViewDataSource {

    // MARK: - Alert View Data Source Functions

    func alertSubject() -> String

    func alertMessage() -> String

    func alertAction() -> String

    func alertHandler() -> (() -> Void)?

}

class AlertView: UIView {

    // MARK: - Instance Properties
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15.0
        containerView.addSubview(self.subjectLabel)
        containerView.addSubview(self.messageLabel)
        containerView.addSubview(self.actionButton)
        containerView.addSubview(self.cancelButton)
        return containerView
    }()
    
    private lazy var subjectLabel: UILabel = {
        let subjectLabel = UILabel()
        subjectLabel.text = self.dataSource.alertSubject()
        subjectLabel.font = Partybox.font.avenirNextMedium(size: 20)
        subjectLabel.textColor = Partybox.color.black
        subjectLabel.textAlignment = .center
        subjectLabel.numberOfLines = 0
        return subjectLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = self.dataSource.alertMessage()
        messageLabel.font = Partybox.font.avenirNextRegular(size: 18)
        messageLabel.textColor = Partybox.color.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    private lazy var actionButton: ActivityIndicatorButton = {
        let actionButton = ActivityIndicatorButton()
        actionButton.setTitle(self.dataSource.alertAction(), for: .normal)
        actionButton.setTitleFont(Partybox.font.avenirNextMediumName, size: 20)
        actionButton.setTitleColor(Partybox.color.white, for: .normal)
        actionButton.setBackgroundColor(Partybox.color.red)
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return actionButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitleFont(Partybox.font.avenirNextRegularName, size: 18)
        cancelButton.setTitleColor(Partybox.color.red, for: .normal)
        cancelButton.setBackgroundColor(Partybox.color.white)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return cancelButton
    }()

    var delegate: AlertViewDelegate!

    var dataSource: AlertViewDataSource!

    // MARK: - Setup Functions
    
    func setupView() {
        self.backgroundColor = Partybox.color.black.withAlphaComponent(0.4)

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
            
            if self.dataSource.alertHandler() == nil {
                make.bottom.equalTo(self.containerView.snp.bottom).offset(-24)
            }
        })
        
        if self.dataSource.alertHandler() == nil {
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
    
    @objc private func actionButtonPressed() {
        self.delegate.alertView(self, actionButtonPressed: true)
    }
    
    @objc private func cancelButtonPressed() {
        self.delegate.alertView(self, cancelButtonPressed: true)
    }
    
}
