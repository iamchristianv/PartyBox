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
    
    var contentView: PartyView!
    
    var delegate: PartyViewControllerDelegate!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = PartyView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: PartyNotification.hostChanged.rawValue, selector: #selector(partyHostChanged))
        self.startObservingNotification(name: PartyNotification.detailsChanged.rawValue, selector: #selector(partyDetailsChanged))
        self.startObservingNotification(name: PartyNotification.peopleChanged.rawValue, selector: #selector(partyPeopleChanged))
        self.startObservingNotification(name: GameNotification.detailsChanged.rawValue, selector: #selector(gameDetailsChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.hostChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.detailsChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.peopleChanged.rawValue)
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
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
        self.showUserWantsToLeavePartyAlert(handler: {
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
    
    @objc func partyHostChanged() {
        self.contentView.reloadTable()
        
        if User.current.name == Party.current.details.hostName {
            self.showUserIsNewPartyHostAlert(handler: nil)
        }
    }
        
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
    
    @objc func gameDetailsChanged() {
        switch Game.current.type {
        case .wannabe:
            if Wannabe.current.details.isSetup {
                self.showStartPartyViewController()
            }
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {
    
    // MARK: - Party View Delegate Functions
    
    func partyView(_ partyView: PartyView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()
        
        Game.current.loadPackCollection(callback: {
            (error) in
            
            self.contentView.stopAnimatingPlayButton()
            
            if let error = error {
                self.showErrorAlert(error: error)
            } else {
                switch Game.current.type {
                case .wannabe:
                    Wannabe.current = Wannabe()
                    self.showSetupWannabeViewController()
                }
            }
        })
    }
    
    func partyView(_ partyView: PartyView, changeButtonPressed: Bool) {
        self.showChangeGameViewController()
    }
    
    func partyView(_ partyView: PartyView, kickButtonPressed selectedPersonName: String) {
        self.showUserWantsToKickPersonFromPartyAlert(handler: {
            guard let person = Party.current.people.person(name: selectedPersonName) else { return }
            
            Party.current.removePerson(name: person.name, callback: {
                (error) in
                
                guard let error = error else { return }
                
                self.showErrorAlert(error: error)
            })
        })
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
