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
            self.contentView.joinButton.addTarget(self, action: #selector(joinButtonPressed), for: .touchUpInside)
        }
    }
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
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
        self.setNavigationBarLeftButton(title: "back", target: self, action: #selector(backButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func joinButtonPressed() {
        guard let inviteCode = self.contentView.inviteCodeTextField.text?.trimmingCharacters(in: .whitespaces), !inviteCode.isEmpty else {
            return
        }
        
        guard let personName = self.contentView.yourNameTextField.text?.trimmingCharacters(in: .whitespaces), !personName.isEmpty else {
            return
        }
        
        Party.join(inviteCode: inviteCode, personName: personName, callback: {
            (party, error) in
            
            if let error = error {
                print(error)
            }
            else if let party = party {
                let partyViewController = PartyViewController(party: party)
                let navigationController = UINavigationController(rootViewController: partyViewController)
                self.present(navigationController)
            }
        })
    }
    
    @objc func backButtonPressed() {
        self.pop()
    }
    
    // MARK: - Action Methods
    
    @objc func hideKeyboard() {
        self.contentView.inviteCodeTextField.resignFirstResponder()
        self.contentView.yourNameTextField.resignFirstResponder()
    }

}
