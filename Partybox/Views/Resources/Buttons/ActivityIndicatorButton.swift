//
//  ActivityIndicatorButton.swift
//  Partybox
//
//  Created by Christian Villa on 1/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ActivityIndicatorButton: UIButton {

    // MARK: - Instance Properties
    
    private var title: String?
    
    private var activityInidicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    // MARK: - Layout Functions

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupBorder()
        self.setupShadow()
    }
    
    // MARK: - Setup Functions
    
    private func setupBorder() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    private func setupShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
    }
    
    // MARK: - Animation Functions
    
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
