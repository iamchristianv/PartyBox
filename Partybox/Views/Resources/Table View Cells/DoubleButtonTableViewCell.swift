//
//  DoubleButtonTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol DoubleButtonTableViewCellDelegate {
    
    func doubleButtonTableViewCell(_ doubleButtonTableViewCell: DoubleButtonTableViewCell, topButtonPressed button: UIButton)
    
    func doubleButtonTableViewCell(_ doubleButtonTableViewCell: DoubleButtonTableViewCell, bottomButtonPressed button: UIButton)
    
}

class DoubleButtonTableViewCell: UITableViewCell {
    
    // MARK: - Class Properties
    
    static let identifier: String = String(describing: DoubleButtonTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var topButton: ActivityButton = {
        let topButton = ActivityButton()
        topButton.setTitleFont(UIFont.avenirNextMediumName, size: 20)
        topButton.setBackgroundColor(UIColor.Partybox.green)
        return topButton
    }()
    
    var bottomButton: ActivityButton = {
        let bottomButton = ActivityButton()
        bottomButton.setTitleFont(UIFont.avenirNextMediumName, size: 20)
        bottomButton.setBackgroundColor(UIColor.Partybox.green)
        return bottomButton
    }()
    
    var delegate: DoubleButtonTableViewCellDelegate!
    
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
        self.topButton.addTarget(self, action: #selector(topButtonPressed), for: .touchUpInside)
        self.bottomButton.addTarget(self, action: #selector(bottomButtonPressed), for: .touchUpInside)
        
        self.addSubview(self.topButton)
        self.addSubview(self.bottomButton)
        
        self.topButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.bottomButton.snp.top).offset(-24)
        })
        
        self.bottomButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.topButton.snp.bottom).offset(24)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
        })
    }
    
    // MARK: - Action Methods
    
    @objc func topButtonPressed() {
        self.delegate.doubleButtonTableViewCell(self, topButtonPressed: self.topButton)
    }
    
    @objc func bottomButtonPressed() {
        self.delegate.doubleButtonTableViewCell(self, bottomButtonPressed: self.bottomButton)
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setTopButtonTitle(_ title: String) {
        self.topButton.setTitle(title, for: .normal)
    }
    
    func setBottomButtonTitle(_ title: String) {
        self.bottomButton.setTitle(title, for: .normal)
    }
    
}
