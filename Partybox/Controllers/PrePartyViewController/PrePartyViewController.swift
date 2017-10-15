//
//  PrePartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/1/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

enum PrePartyViewControllerType: String {
    
    case startParty = "Start Party"
    
    case joinParty = "Join Party"
    
}

class PrePartyViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var firstPromptLabel: UILabel! {
        didSet {
            if self.type == .startParty {
                self.firstPromptLabel.text = "Party Name"
            }
            else if self.type == .joinParty {
                self.firstPromptLabel.text = "Invite Code"
            }
        }
    }
    
    @IBOutlet weak var firstTextField: UITextField!
    
    @IBOutlet weak var secondPromptLabel: UILabel! {
        didSet {
            self.secondPromptLabel.text = "Your Name"
        }
    }
    
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    
    var type: PrePartyViewControllerType?
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    // MARK: - Configuration
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(type?.rawValue)
        self.setNavigationBarLeftButton(title: "back", target: self, action: #selector(backButtonPressed))
    }
    
    // MARK: - Navigation
    
    @objc func backButtonPressed() {
        self.dismissController()
    }
    
    // MARK: - IBActions
    
    @IBAction func continueButtonPressed() {
        if let firstEntry = self.firstTextField.text?.trimmingCharacters(in: .whitespaces), firstEntry.isEmpty {
            // show missing fields
        }
        
        if let secondEntry = self.secondTextField.text?.trimmingCharacters(in: .whitespaces), secondEntry.isEmpty {
            // show missing fields
        }
        
        guard let firstEntry = self.firstTextField.text?.trimmingCharacters(in: .whitespaces), !firstEntry.isEmpty else {
            return
        }
        
        guard let secondEntry = self.secondTextField.text?.trimmingCharacters(in: .whitespaces), !secondEntry.isEmpty else {
            return
        }
        
        if self.type == .startParty {
            Party.start(partyName: firstEntry, personName: secondEntry, callback: {
                (party, person, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let party = party, let person = person else {
                    print("We encountered an error while starting your party\n\nPlease try again")
                    return
                }
                
                self.showPartyController(party: party, person: person)
            })
        }
        else if self.type == .joinParty {
            Party.join(inviteCode: firstEntry, personName: secondEntry, callback: {
                (party, person, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let party = party, let person = person else {
                    print("We encountered an error while joining your party\n\nPlease try again")
                    return
                }
                
                self.showPartyController(party: party, person: person)
            })
        }
    }
    
}
