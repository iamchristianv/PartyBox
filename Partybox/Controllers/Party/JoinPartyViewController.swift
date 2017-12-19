//
//  JoinPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class JoinPartyViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: JoinPartyView! {
        didSet {
            self.contentView.backgroundButton.addTarget(self, action: #selector(backgroundButtonPressed), for: .touchUpInside)
            self.contentView.joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        }
    }
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = JoinPartyView()
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Join Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func joinButtonPressed() {
        guard let inviteCode = self.contentView.inviteCodeTextField.text?.trimmingCharacters(in: .whitespaces), !inviteCode.isEmpty else {
            return
        }
        
        guard let personName = self.contentView.yourNameTextField.text?.trimmingCharacters(in: .whitespaces), !personName.isEmpty else {
            return
        }
        
        Session.join(code: inviteCode, personName: personName, callback: {
            (error) in
            
            if let error = error {
                print(error)
                return
            }
            
            self.showPartyViewController()
        })
    }
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Methods
    
    @objc func backgroundButtonPressed() {
        self.contentView.inviteCodeTextField.resignFirstResponder()
        self.contentView.yourNameTextField.resignFirstResponder()
    }

}
