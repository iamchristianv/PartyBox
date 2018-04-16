//
//  StartPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import UIKit

class StartPartyViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    private var contentView: StartPartyView = StartPartyView()
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.contentView.dataSource = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
    }
    
    private func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.red)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}

extension StartPartyViewController: StartPartyViewDelegate {
    
    // MARK: - Start Party View Delegate Functions
    
    func startPartyView(_ startPartyView: StartPartyView, startButtonPressed: Bool) {
        self.contentView.startAnimatingStartButton()
        
        Database.current.startParty(userName: self.contentView.yourName(), partyName: self.contentView.partyName(), callback: {
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

extension StartPartyViewController: StartPartyViewDataSource {

    // MARK: - Start Party View Data Source Functions

}

extension StartPartyViewController: PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        self.showUserWasKickedFromPartyAlert()
    }
    
}
