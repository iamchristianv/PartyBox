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
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.Partybox.avenirNextRegular(size: 18)
        contentLabel.textColor = UIColor.Partybox.black
        return contentLabel
    }()
    
    lazy var selectableView: SelectableView = {
        let selectableView = SelectableView()
        return selectableView
    }()
    
    lazy var underlineLabel: UILabel = {
        let underlineLabel = UILabel()
        underlineLabel.backgroundColor = UIColor.Partybox.lightGray
        return underlineLabel
    }()
    
    // MARK: - Initialization Functions
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    func setupSubviews() {
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
    
    // MARK: - Setter Functions
    
    func setContent(_ content: String) {
        self.contentLabel.text = content
    }
    
    func setSelected(_ selected: Bool) {
        self.selectableView.setSelected(selected)
    }
    
}
