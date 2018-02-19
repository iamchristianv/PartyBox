//
//  ButtonCollectionTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol ButtonCollectionTableViewCellDelegate {
    
    // MARK: - Button Collection Table View Cell Delegate Methods
    
    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, topButtonPressed button: UIButton)
    
    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, bottomButtonPressed button: UIButton)
    
}

class ButtonCollectionTableViewCell: UITableViewCell {
    
    // MARK: - Class Properties
    
    static let identifier: String = String(describing: ButtonCollectionTableViewCell.self)
    
    // MARK: - Instance Properties
    
    lazy var topButton: ActivityButton = {
        let topButton = ActivityButton()
        topButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        topButton.setBackgroundColor(UIColor.Partybox.green)
        return topButton
    }()
    
    lazy var bottomButton: ActivityButton = {
        let bottomButton = ActivityButton()
        bottomButton.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        bottomButton.setBackgroundColor(UIColor.Partybox.green)
        return bottomButton
    }()
    
    var delegate: ButtonCollectionTableViewCellDelegate!
    
    // MARK: - Initialization Methods
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.topButton)
        self.addSubview(self.bottomButton)
        
        self.topButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(8)
        })
        
        self.topButton.addTarget(self, action: #selector(topButtonPressed), for: .touchUpInside)
        
        self.bottomButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(220)
            make.height.equalTo(55)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.topButton.snp.bottom).offset(24)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
        })
        
        self.bottomButton.addTarget(self, action: #selector(bottomButtonPressed), for: .touchUpInside)

    }
    
    // MARK: - Action Methods
    
    @objc func topButtonPressed() {
        self.delegate.buttonCollectionTableViewCell(self, topButtonPressed: self.topButton)
    }
    
    @objc func bottomButtonPressed() {
        self.delegate.buttonCollectionTableViewCell(self, bottomButtonPressed: self.bottomButton)
    }
    
    // MARK: - Setter Methods
    
    func setTopButtonTitle(_ title: String) {
        self.topButton.setTitle(title, for: .normal)
    }
    
    func setBottomButtonTitle(_ title: String) {
        self.bottomButton.setTitle(title, for: .normal)
    }
    
}
