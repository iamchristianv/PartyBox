//
//  SingleButtonTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol SingleButtonTableViewCellDelegate {

    func singleButtonTableViewCell(_ singleButtonTableViewCell: SingleButtonTableViewCell, buttonPressed button: UIButton)
    
}

class SingleButtonTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: SingleButtonTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitleFont(UIFont.avenirNextRegularName, size: 18)
        return button
    }()
    
    var delegate: SingleButtonTableViewCellDelegate!
    
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
        self.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        self.addSubview(self.button)
        
        self.button.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
        })
    }
    
    // MARK: - Action Methods
    
    @objc func buttonPressed() {
        self.delegate.singleButtonTableViewCell(self, buttonPressed: self.button)
    }
    
    // MARK: - Setter Methods
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    func setButtonTitle(_ title: String) {
        self.button.setTitle(title, for: .normal)
    }

}
