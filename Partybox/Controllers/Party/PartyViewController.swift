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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.startObservingPartyDetailsChanges(selector: #selector(partyDetailsChanged))
        self.startObservingPartyPeopleChanges(selector: #selector(partyPeopleChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingPartyDetailsChanges()
        self.stopObservingPartyPeopleChanges()
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(Party.details.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        
        if User.name == Party.details.hostName {
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
            if User.name == Party.details.hostName && Party.people.count > 1 {
                self.showChangeHostViewController(delegate: self)
            } else {
                self.dismissViewController(animated: true, completion: nil)
                Party.end()
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
        
        if Party.people.person(name: User.name) == nil {
            self.dismissViewController(animated: true, completion: nil)
            self.delegate.partyViewController(self, userKicked: true)
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
        guard let person = Party.people.person(index: selectedPersonIndex) else { return }
        
        if person.name == User.name {
            let subject = "Slow down ✋"
            let message = "You can't kick yourself from your own party"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        } else {
            let subject = "Slow down ✋"
            let message = "Are you sure you want to kick them from your party?"
            let action = "Kick"
            self.showAlert(subject: subject, message: message, action: action, handler: {
                let path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.people.rawValue)/\(person.name)"
                database.child(path).removeValue()
            })
        }
    }
    
}

extension PartyViewController: ChangeHostViewControllerDelegate {
    
    // MARK: - Change Host View Controller Delegate Functions
    
    func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostChanged: Bool) {
        self.dismissViewController(animated: true, completion: nil)
        Party.end()
    }
    
}
