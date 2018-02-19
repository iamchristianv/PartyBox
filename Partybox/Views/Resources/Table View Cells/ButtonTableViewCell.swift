//
//  ButtonTableViewCell.swift
//  Partybox
//
//  Created by Christian Villa on 11/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {

    func buttonTableViewCell(_ buttonTableViewCell: ButtonTableViewCell, buttonPressed button: UIButton)
    
}

class ButtonTableViewCell: UITableViewCell {

    // MARK: - Class Properties
    
    static let identifier: String = String(describing: ButtonTableViewCell.self)
    
    // MARK: - Instance Properties
    
    var button: ActivityButton = {
        let button = ActivityButton()
        button.setTitleFont(UIFont.avenirNextMediumName, size: 22)
        return button
    }()
    
    var delegate: ButtonTableViewCellDelegate!
    
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
        self.delegate.buttonTableViewCell(self, buttonPressed: self.button)
    }
    
    // MARK: - Animationg Methods
    
    func startAnimatingButton() {
        self.button.startAnimating()
    }
    
    func stopAnimatingButton() {
        self.button.stopAnimating()
    }
    
    // MARK: - Setter Methods
    
    func setButtonTitle(_ title: String) {
        self.button.setTitle(title, for: .normal)
    }
    
    func setButtonBackgroundColor(_ color: UIColor) {
        self.button.setBackgroundColor(color)
    }

}
