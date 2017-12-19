//
//  WaitingTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/7/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class WaitingTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: WaitingTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var containerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    var promptLabel: UILabel = {
        let promptLabel = UILabel()
        promptLabel.textColor = .black
        promptLabel.font = UIFont.avenirNextRegular(size: 16)
        return promptLabel
    }()
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = false
        self.setBackgroundColor(.white)
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicatorView.startAnimating()
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.containerView.addSubview(self.activityIndicatorView)
        self.containerView.addSubview(self.promptLabel)
        
        self.addSubview(self.containerView)
        
        self.containerView.snp.remakeConstraints({
            (make) in
            
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.activityIndicatorView.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.containerView.snp.leading)
            make.top.equalTo(self.containerView.snp.top)
            make.trailing.equalTo(self.promptLabel.snp.leading).offset(-8)
            make.bottom.equalTo(self.containerView.snp.bottom)
        })
        
        self.promptLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.activityIndicatorView.snp.trailing).offset(8)
            make.top.equalTo(self.containerView.snp.top)
            make.trailing.equalTo(self.containerView.snp.trailing)
            make.bottom.equalTo(self.containerView.snp.bottom)
        })
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setPrompt(_ prompt: String) {
        self.promptLabel.text = prompt
    }

}
