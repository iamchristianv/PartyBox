//
//  ActivityButton.swift
//  Partybox
//
//  Created by Christian Villa on 1/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ActivityButton: UIButton {

    // MARK: - Instance Properties
    
    var title: String?
    
    var activityInidicator: UIActivityIndicatorView!
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureBorder() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func configureShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
    }
    
    func configureActivityIndicator() {
        self.activityInidicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    }
    
    // MARK: - Layout Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureBorder()
        self.configureShadow()
    }
    
    // MARK: - Animation Methods
    
    func startAnimating() {
        if self.activityInidicator.isAnimating {
            return
        }
        
        self.isUserInteractionEnabled = false
        
        self.title = self.titleLabel?.text
        self.setTitle(nil, for: .normal)
        
        self.activityInidicator.startAnimating()
        self.activityInidicator.frame = self.bounds
        self.addSubview(self.activityInidicator)
    }
    
    func stopAnimating() {
        if !self.activityInidicator.isAnimating {
            return
        }
        
        self.isUserInteractionEnabled = true
        
        self.activityInidicator.removeFromSuperview()
        self.activityInidicator.frame = .zero
        self.activityInidicator.stopAnimating()
        
        self.setTitle(self.title, for: .normal)
    }

}
