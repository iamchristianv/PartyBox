//
//  ManagePartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: ManagePartyView = ManagePartyView()
    
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
        self.setNavigationBarTitle("Manage Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}

extension ManagePartyViewController: ManagePartyViewDelegate {
    
    // MARK: - Manage Party View Delegate Functions
    
    func managePartyView(_ managePartyView: ManagePartyView, saveButtonPressed: Bool) {
        self.contentView.checkPartyNameField()
        
        guard let partyName = self.contentView.partyNameValue() else { return }
        
        self.contentView.startAnimatingSaveButton()
        
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
        let value = [PartyDetailsKey.name.rawValue: partyName]
        
        Reference.child(path).updateChildValues(value, withCompletionBlock: {
            (error, _) in
            
            self.contentView.stopAnimatingSaveButton()
            
            if let _ = error {
                let subject = "Woah woah!"
                let message = "We were unable to save your changes\n\nPlease try again"
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                self.dismissViewController(animated: true, completion: nil)
            }
        })
    }
    
}
