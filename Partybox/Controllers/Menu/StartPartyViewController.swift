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
    
    var contentView: StartPartyView = StartPartyView()
    
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
        let partyName = self.contentView.partyNameValue()
        let userName = self.contentView.yourNameValue()
        
        if partyName == nil || userName == nil {
            return
        }
        
        self.contentView.startAnimatingStartButton()
        
        Party.start(userName: userName!, partyName: partyName!, callback: {
            (error) in
             
            self.contentView.stopAnimatingStartButton()
            
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

extension StartPartyViewController: PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        let subject = "Whoops!"
        let message = "You were kicked from the party by the host"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }
    
}
