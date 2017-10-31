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
            self.contentView.startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
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
        self.contentView = StartPartyView()
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "back", target: self, action: #selector(backButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func startButtonPressed() {
        guard let partyName = self.contentView.partyNameTextField.text?.trimmingCharacters(in: .whitespaces), !partyName.isEmpty else {
            return
        }
        
        guard let personName = self.contentView.yourNameTextField.text?.trimmingCharacters(in: .whitespaces), !personName.isEmpty else {
            return
        }
        
        Party.start(partyName: partyName, personName: personName, callback: {
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
        self.contentView.partyNameTextField.resignFirstResponder()
        self.contentView.yourNameTextField.resignFirstResponder()
    }

}
