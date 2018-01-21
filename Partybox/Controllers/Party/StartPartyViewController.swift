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
    
    var contentView: StartPartyView!
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureStatusBar()
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.configureContentView()
    }
    
    // MARK: - Configuration Methods
    
    func configureStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.red)
    }
    
    func configureContentView() {
        self.contentView = StartPartyView()
        self.contentView.backgroundButton.addTarget(self, action: #selector(backgroundButtonPressed), for: .touchUpInside)
        self.contentView.continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        self.view = self.contentView
    }
    
    // MARK: - Action Methods
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    @objc func backgroundButtonPressed() {
        self.contentView.partyNameTextField.resignFirstResponder()
        self.contentView.yourNameTextField.resignFirstResponder()
    }
    
    @objc func continueButtonPressed() {
        let partyName = self.contentView.partyNameTextField.text!
        var partyNameValid = false
        
        if partyName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.contentView.showPartyNameStatus("Required")
        }
        else {
            partyNameValid = true
            self.contentView.hidePartyNameStatus()
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
        
        if !partyNameValid || !personNameValid {
            return
        }
        
        self.contentView.startAnimatingContinueButton()
        
        Party.start(partyName: partyName, personName: personName, callback: {
            (error) in
            
            self.contentView.stopAnimatingContinueButton()
            
            if let error = error {
                self.showAlert(subject: "Woah there ✋", message: error, action: "Okay", block: nil)
                return
            }
            
            self.showPartyViewController()
        })
    }
    
    // MARK: - Navigation Methods
    
    func showPartyViewController() {
        self.present(UINavigationController(rootViewController: PartyViewController()), animated: true, completion: nil)
    }

}
