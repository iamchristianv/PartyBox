//
//  AlertViewController.swift
//  Partybox
//
//  Created by Christian Villa on 11/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class AlertViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: AlertView! {
        didSet {
            self.contentView.backgroundButton.addTarget(self, action: #selector(backgroundButtonPressed), for: .touchUpInside)
            self.contentView.actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        }
    }
    
    var alert: String
    
    var message: String
    
    var action: String
    
    var actionBlock: (() -> ())?
    
    // MARK: - Initialization Methods
    
    init(alert: String, message: String, action: String, actionBlock: (() -> ())?) {
        self.alert = alert
        self.message = message
        self.action = action
        self.actionBlock = actionBlock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = AlertView(alert: self.alert, message: self.message, action: self.action)
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.hideNavigationBar()
    }
    
    // MARK: - Action Methods
    
    @objc func actionButtonPressed() {
        self.dismiss(animated: false, completion: {
            if let actionBlock = self.actionBlock {
                actionBlock()
            }
        })
    }
    
    @objc func backgroundButtonPressed() {
        self.dismiss(animated: false, completion: nil)
    }

}
