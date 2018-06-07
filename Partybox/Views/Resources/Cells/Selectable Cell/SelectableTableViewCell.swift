//
//  SelectableTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SelectableTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: SelectableTableViewCell.self)
    
    // MARK: - Instance Properties
    
    private lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = Partybox.fonts.avenirNextRegular(size: 18)
        contentLabel.textColor = Partybox.colors.black
        return contentLabel
    }()
    
    private lazy var selectableView: SelectableView = {
        let selectableView = SelectableView()
        return selectableView
    }()
    
    private lazy var underlineLabel: UILabel = {
        let underlineLabel = UILabel()
        underlineLabel.backgroundColor = Partybox.colors.lightGray
        return underlineLabel
    }()

    var content: String {
        set {
            self.contentLabel.text = newValue
        }
        get {
            return self.contentLabel.text!
        }
    }

    var value: Any!

    // MARK: - Configuration Functions

    func configure(content: String, selected: Bool, value: Any) {
        self.contentLabel.text = content
        self.selectableView = SelectableView.construct(selected: selected)
        self.value = value
        self.setupView()
    }

    // MARK: - Setup Functions
    
    private func setupView() {
        self.backgroundColor = Partybox.colors.white
        self.isUserInteractionEnabled = true
        self.selectionStyle = .none

        self.addSubview(self.contentLabel)
        self.addSubview(self.selectableView)
        self.addSubview(self.underlineLabel)
        
        self.contentLabel.snp.remakeConstraints({
            (make) in
            
            make.leading.equalTo(self.snp.leading).offset(16)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
        
        self.selectableView.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.centerY.equalTo(self.snp.centerY)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
        })
        
        self.underlineLabel.snp.remakeConstraints({
            (make) in
            
            make.height.equalTo(0.5)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
    
}
