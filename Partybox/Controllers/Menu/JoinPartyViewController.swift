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
        self.setupViewController()
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.setupNavigationBar()
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
        self.contentView.checkInviteCodeField()
        self.contentView.checkYourNameField()
        
        guard let partyId = self.contentView.inviteCodeValue() else { return }
        guard let userName = self.contentView.yourNameValue() else { return }
        
        self.contentView.startAnimatingJoinButton()
        
        Reference.current.joinParty(userName: userName, partyId: partyId, callback: {
            (error) in
            
            self.contentView.stopAnimatingJoinButton()
            
            if let error = error {
                self.showErrorAlert(error: error, handler: nil)
            } else {
                self.showPartyViewController(delegate: self)
            }
        })
    }
    
}

extension JoinPartyViewController: PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        self.showUserWasKickedFromPartyAlert(handler: nil)
    }
    
}
