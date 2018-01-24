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
    
    var contentView: JoinPartyView!
    
    // MARK: - View Controller Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupStatusBar()
        self.setupNavigationBar()
    }
    
    override func loadView() {
        self.setupContentView()
    }
    
    // MARK: - Setup Functions
    
    func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Join Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.blue)
    }
    
    func setupContentView() {
        self.contentView = JoinPartyView()
        self.contentView.backgroundButton.addTarget(self, action: #selector(backgroundButtonPressed), for: .touchUpInside)
        self.contentView.continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        self.view = self.contentView
    }
    
    // MARK: - Action Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    @objc func backgroundButtonPressed() {
        self.contentView.inviteCodeTextField.resignFirstResponder()
        self.contentView.yourNameTextField.resignFirstResponder()
    }
    
    @objc func continueButtonPressed() {
        let inviteCode = self.contentView.inviteCodeTextField.text!
        var inviteCodeValid = false
        
        if inviteCode.trimmingCharacters(in: .whitespaces).isEmpty {
            self.contentView.showInviteCodeStatus("Required")
        }
        else if !inviteCode.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.contentView.showInviteCodeStatus("No spaces or special characters")
        }
        else {
            inviteCodeValid = true
            self.contentView.hideInviteCodeStatus()
        }
        
        let personName = self.contentView.yourNameTextField.text!
        var personNameValid = false
        
        if personName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.contentView.showYourNameStatus("Required")
        }
        else if !personName.trimmingCharacters(in: .alphanumerics).isEmpty {
            self.contentView.showYourNameStatus("No spaces or special characters")
        }
        else {
            personNameValid = true
            self.contentView.hideYourNameStatus()
        }
        
        if !inviteCodeValid || !personNameValid {
            return
        }
        
        self.contentView.startAnimatingContinueButton()
        
        Party.join(inviteCode: inviteCode, personName: personName, callback: {
            (error) in
            
            self.contentView.stopAnimatingContinueButton()
            
            if let error = error {
                self.showAlert(subject: "Woah there ✋", message: error, action: "Okay", handler: nil)
                return
            }
            
            self.showPartyViewController()
        })
    }
    
    // MARK: - Navigation Functions
    
    func showPartyViewController() {
        self.present(UINavigationController(rootViewController: PartyViewController()), animated: true, completion: nil)
    }

}
