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
    
    // MARK: - Initialization Methods
    
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
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.configureContentView()
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.hideNavigationBar()
    }
    
    func configureContentView() {
        self.contentView = AlertView(subject: self.subject, message: self.message, action: self.action)
        self.contentView.actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        self.view = self.contentView
    }
    
    // MARK: - Action Methods
    
    @objc func actionButtonPressed() {
        self.dismiss(animated: false, completion: {
            if let handler = self.handler {
                handler()
            }
        })
    }

}
