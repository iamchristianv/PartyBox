//
//  StartPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var contentView: StartPartyView!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = StartPartyView()
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
        self.showNavigationBar()
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.red)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}

extension StartPartyViewController: StartPartyViewDelegate {
    
    // MARK: - Start Party View Delegate Functions
    
    func startPartyView(_ startPartyView: StartPartyView, startButtonPressed: Bool) {
        self.contentView.startAnimatingStartButton()
        
        Reference.current.startParty(userName: self.contentView.yourNameValue(), partyName: self.contentView.partyNameValue(), callback: {
            (error) in
            
            self.contentView.stopAnimatingStartButton()
            
            if let error = error {
                self.showErrorAlert(error: error)
            } else {
                self.showPartyViewController(delegate: self)
            }
        })
    }

}

extension StartPartyViewController: PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        self.showUserWasKickedFromPartyAlert()
    }
    
}
