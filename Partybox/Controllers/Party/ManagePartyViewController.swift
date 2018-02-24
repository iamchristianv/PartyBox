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
        
        Reference.current.setNameForParty(name: partyName, callback: {
            (error) in
            
            self.contentView.stopAnimatingSaveButton()
            
            if let error = error {
                let subject = "Woah woah!"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                self.dismissViewController(animated: true, completion: nil)
            }
        })
    }
    
}
