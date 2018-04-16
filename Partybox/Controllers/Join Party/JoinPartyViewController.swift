//
//  JoinPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import UIKit

class JoinPartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: JoinPartyView!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = JoinPartyView()
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
        self.setNavigationBarTitle("Join Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.blue)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}

extension JoinPartyViewController: JoinPartyViewDelegate {
    
    // MARK: - Join Party View Delegate Functions
    
    func joinPartyView(_ joinPartyView: JoinPartyView, joinButtonPressed: Bool) {
        self.contentView.startAnimatingJoinButton()
        
        Database.current.joinParty(userName: self.contentView.yourNameValue(), partyId: self.contentView.inviteCodeValue(), callback: {
            (error) in
            
            self.contentView.stopAnimatingJoinButton()
            
            if let error = error {
                self.showErrorAlert(error: error)
            } else {
                self.showPartyViewController(delegate: self)
            }
        })
    }
    
}

extension JoinPartyViewController: PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        self.showUserWasKickedFromPartyAlert()
    }
    
}
