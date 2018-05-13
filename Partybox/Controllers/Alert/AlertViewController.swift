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
    
    private var contentView: AlertView = AlertView()
    
    var alert: Alert!

    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.contentView.dataSource = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.setupNavigationBar()
        self.setupView()
    }
    
    private func setupNavigationBar() {
        self.hideNavigationBar()
    }

    private func setupView() {
        self.contentView.setupView()
    }

}

extension AlertViewController: AlertViewDelegate {
    
    // MARK: - Alert View Delegate Functions
    
    internal func alertView(_ alertView: AlertView, actionButtonPressed: Bool) {
        self.dismiss(animated: false, completion: self.alert.handler)
    }
    
    internal func alertView(_ alertView: AlertView, cancelButtonPressed: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension AlertViewController: AlertViewDataSource {

    // MARK: - Alert View Data Source Functions

    internal func alertSubject() -> String {
        return self.alert.subject
    }

    internal func alertMessage() -> String {
        return self.alert.message
    }

    internal func alertAction() -> String {
        return self.alert.action
    }

    internal func alertHandler() -> (() -> Void)? {
        return self.alert.handler
    }

}
