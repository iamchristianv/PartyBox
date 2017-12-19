//
//  StartPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyViewController: BaseViewController {
    
    // MARK: - Instance Properties
    
    var contentView: StartPartyView! {
        didSet {
            self.contentView.backgroundButton.addTarget(self, action: #selector(backgroundButtonPressed), for: .touchUpInside)
            self.contentView.startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        }
    }
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = StartPartyView()
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func startButtonPressed() {
        guard let partyName = self.contentView.partyNameTextField.text?.trimmingCharacters(in: .whitespaces), !partyName.isEmpty else {
            return
        }
        
        guard let personName = self.contentView.yourNameTextField.text?.trimmingCharacters(in: .whitespaces), !personName.isEmpty else {
            return
        }
        
        Session.start(partyName: partyName, personName: personName, callback: {
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
        self.contentView.partyNameTextField.resignFirstResponder()
        self.contentView.yourNameTextField.resignFirstResponder()
    }

}
