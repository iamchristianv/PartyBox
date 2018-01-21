//
//  ButtonCollectionTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol ButtonCollectionTableViewCellDelegate {
    
    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, leftButtonPressed button: UIButton)
    
    func buttonCollectionTableViewCell(_ buttonCollectionTableViewCell: ButtonCollectionTableViewCell, rightButtonPressed button: UIButton)
    
}

class ButtonCollectionTableViewCell: UITableViewCell {
    
    // MARK: - Class Properties
    
    static let identifier: String = String(describing: ButtonCollectionTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var leftButton: ActivityButton = {
        let leftButton = ActivityButton()
        leftButton.setTitleFont(UIFont.avenirNextMediumName, size: 20)
        leftButton.setBackgroundColor(UIColor.Partybox.green)
        return leftButton
    }()
    
    var rightButton: ActivityButton = {
        let rightButton = ActivityButton()
        rightButton.setTitleFont(UIFont.avenirNextMediumName, size: 20)
        rightButton.setBackgroundColor(UIColor.Partybox.green)
        return rightButton
    }()
    
    var delegate: ButtonCollectionTableViewCellDelegate!
    
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
        self.leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        
        self.addSubview(self.leftButton)
        self.addSubview(self.rightButton)
        
        self.leftButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(self.rightButton.snp.width)
            make.height.equalTo(50)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.trailing.equalTo(self.rightButton.snp.leading).offset(-24)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
        })
        
        self.rightButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(self.leftButton.snp.width)
            make.height.equalTo(50)
            make.leading.equalTo(self.leftButton.snp.trailing).offset(24)
            make.trailing.equalTo(self.snp.trailing).offset(-24)
            make.top.equalTo(self.snp.top).offset(8)
            make.bottom.equalTo(self.snp.bottom).offset(-24)
        })
    }
    
    // MARK: - Action Methods
    
    @objc func leftButtonPressed() {
        self.delegate.buttonCollectionTableViewCell(self, leftButtonPressed: self.leftButton)
    }
    
    @objc func rightButtonPressed() {
        self.delegate.buttonCollectionTableViewCell(self, rightButtonPressed: self.rightButton)
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setLeftButtonTitle(_ title: String) {
        self.leftButton.setTitle(title, for: .normal)
    }
    
    func setRightButtonTitle(_ title: String) {
        self.rightButton.setTitle(title, for: .normal)
    }
    
}
