//
//  AlertViewController.swift
//  Partybox
//
//  Created by Christian Villa on 11/8/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: AlertView!
    
    var subject: String
    
    var message: String
    
    var action: String
    
    var handler: (() -> ())?
    
    // MARK: - Initialization Functions
    
    init(subject: String, message: String, action: String, handler: (() -> ())?) {
        self.subject = subject
        self.message = message
        self.action = action
        self.handler = handler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = AlertView(subject: self.subject, message: self.message, action: self.action)
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        UIApplication.shared.statusBarStyle = .lightContent
        self.setupNavigationBar()
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.hideNavigationBar()
    }

}

extension AlertViewController: AlertViewDelegate {
    
    // MARK: - Alert View Delegate Functions
    
    func alertView(_ alertView: AlertView, backgroundButtonPressed: Bool) {
        self.dismissViewController(animated: false, completion: nil)
    }
    
    func alertView(_ alertView: AlertView, actionButtonPressed: Bool) {
        self.dismissViewController(animated: false, completion: {
            guard let handler = self.handler else { return }
            handler()
        })
    }
    
}
