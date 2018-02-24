//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

protocol PartyViewControllerDelegate {
    
    // MARK: - Party View Controller Delegate Functions
    
    func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool)
    
}

class PartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: PartyView = PartyView()
    
    var delegate: PartyViewControllerDelegate!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.startObservingPartyDetailsChanges(selector: #selector(partyDetailsChanged))
        self.startObservingPartyPeopleChanges(selector: #selector(partyPeopleChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingPartyDetailsChanges()
        self.stopObservingPartyPeopleChanges()
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(Party.current.details.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        
        if User.current.name == Party.current.details.hostName {
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }
        
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func leaveButtonPressed() {
        let subject = "Hold on ✋"
        let message = "Are you sure you want to leave the party?"
        let action = "Leave"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            if User.current.name == Party.current.details.hostName && Party.current.people.count > 1 {
                self.showChangeHostViewController(delegate: self)
            } else {
                self.dismissViewController(animated: true, completion: {
                    Reference.current.endParty()
                })
            }
        })
    }
    
    @objc func manageButtonPressed() {
        self.showManagePartyViewController()
    }
    
    // MARK: - Notification Functions
        
    @objc func partyDetailsChanged() {
        self.contentView.reloadTable()
        self.setupNavigationBar()
    }
    
    @objc func partyPeopleChanged() {
        self.contentView.reloadTable()
        
        if Party.current.people.person(name: User.current.name) == nil {
            self.dismissViewController(animated: true, completion: {
                self.delegate.partyViewController(self, userKicked: true)
            })
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {
    
    // MARK: - Party View Delegate Functions
    
    func partyView(_ partyView: PartyView, playButtonPressed: Bool) {
        switch Game.type {
        case .wannabe:
            self.showSetupWannabeViewController()
        }
    }
    
    func partyView(_ partyView: PartyView, changeButtonPressed: Bool) {
        self.showChangeGameViewController()
    }
    
    func partyView(_ partyView: PartyView, kickButtonPressed selectedPersonIndex: Int) {
        guard let person = Party.current.people.person(index: selectedPersonIndex) else { return }
        
        if person.name == User.current.name {
            let subject = "Slow down ✋"
            let message = "Are you sure you want to leave your own party?"
            let action = "Leave"
            self.showAlert(subject: subject, message: message, action: action, handler: {
                if User.current.name == Party.current.details.hostName && Party.current.people.count > 1 {
                    self.showChangeHostViewController(delegate: self)
                } else {
                    self.dismissViewController(animated: true, completion: {
                        Reference.current.endParty()
                    })
                }
            })
        } else {
            let subject = "Slow down ✋"
            let message = "Are you sure you want to kick them from your party?"
            let action = "Kick"
            self.showAlert(subject: subject, message: message, action: action, handler: {
                Reference.current.removePersonFromParty(name: person.name, callback: {
                    (error) in
                    
                    if let error = error {
                        let subject = "Uh oh"
                        let message = error
                        let action = "Okay"
                        self.showAlert(subject: subject, message: message, action: action, handler: nil)
                    }
                })
            })
        }
    }
    
}

extension PartyViewController: ChangeHostViewControllerDelegate {
    
    // MARK: - Change Host View Controller Delegate Functions
    
    func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostChanged: Bool) {
        self.dismissViewController(animated: true, completion: {
            Reference.current.endParty()
        })
    }
    
}
