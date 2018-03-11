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
    
    var alert: Alert
    
    // MARK: - Initialization Functions
    
    init(alert: Alert) {
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = AlertView(alert: self.alert)
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
    }
    
    func setupNavigationBar() {
        self.hideNavigationBar()
    }

}

extension AlertViewController: AlertViewDelegate {
    
    // MARK: - Alert View Delegate Functions
    
    func alertView(_ alertView: AlertView, actionButtonPressed: Bool) {
        self.dismissViewController(animated: false, completion: {
            if let handler = self.alert.handler {
                handler()
            }
        })
    }
    
    func alertView(_ alertView: AlertView, cancelButtonPressed: Bool) {
        self.dismissViewController(animated: false, completion: nil)
    }
    
}
