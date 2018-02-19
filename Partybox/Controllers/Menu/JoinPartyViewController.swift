//
//  JoinPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class JoinPartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: JoinPartyView = JoinPartyView()
    
    // MARK: - View Controller Functions
    
    override func loadView() {
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
        let partyId = self.contentView.inviteCodeValue()
        let userName = self.contentView.yourNameValue()
        
        if partyId == nil || userName == nil {
            return
        }
        
        self.contentView.startAnimatingJoinButton()
        
        Party.start(userName: userName!, partyId: partyId!, callback: {
            (error) in
            
            self.contentView.stopAnimatingJoinButton()
            
            if let error = error {
                let subject = "Woah there ✋"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                self.showPartyViewController(delegate: self)
            }
        })
    }
    
}

extension JoinPartyViewController: PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        let subject = "Whoops!"
        let message = "You were kicked from the party by the host"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }
    
}
