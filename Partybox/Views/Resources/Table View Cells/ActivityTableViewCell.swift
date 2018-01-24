//
//  ActivityTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: ActivityTableViewCell.self)
    
    // MARK: - Instance Properties
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.addSubview(self.activityIndicator)
        containerView.addSubview(self.promptLabel)
        return containerView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.font = UIFont.avenirNextRegular(size: 18)
        promptLabel.textColor = UIColor.Partybox.black
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.startAnimating()
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.containerView)
        
        self.containerView.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
        })
        
        self.activityIndicator.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.containerView.snp.leading)
            make.trailing.equalTo(self.promptLabel.snp.leading).offset(-8)
            make.top.equalTo(self.containerView.snp.top)
            make.bottom.equalTo(self.containerView.snp.bottom)
        })
        
        self.promptLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.activityIndicator.snp.trailing).offset(8)
            make.trailing.equalTo(self.containerView.snp.trailing)
            make.top.equalTo(self.containerView.snp.top)
            make.bottom.equalTo(self.containerView.snp.bottom)
        })
    }
    
    // MARK: - Setter Methods
    
    func setPrompt(_ prompt: String) {
        self.promptLabel.text = prompt
    }

}
