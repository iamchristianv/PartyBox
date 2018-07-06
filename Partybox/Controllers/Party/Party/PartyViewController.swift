//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: UIViewController {

    // MARK: - Instance Properties

    private var store: Store!

    private var party: Party!
    
    private var contentView: PartyView!

    private var delegate: PartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: PartyViewControllerDelegate) -> PartyViewController {
        let controller = PartyViewController()
        controller.store = store
        controller.party = party
        controller.contentView = PartyView.construct(delegate: controller, dataSource: controller)
        controller.delegate = delegate
        return controller
    }
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.startObservingNotification(name: PartyNotification.nameChanged.rawValue,
                                        selector: #selector(partyNameChanged))
        self.startObservingNotification(name: PartyNotification.statusChanged.rawValue,
                                        selector: #selector(partyStatusChanged))
        self.startObservingNotification(name: PartyNotification.gameNameChanged.rawValue,
                                        selector: #selector(partyGameNameChanged))
        self.startObservingNotification(name: PartyNotification.hostNameChanged.rawValue,
                                        selector: #selector(partyHostNameChanged))
        self.startObservingNotification(name: PartyNotification.personAdded.rawValue,
                                        selector: #selector(partyPersonAdded))
        self.startObservingNotification(name: PartyNotification.personChanged.rawValue,
                                        selector: #selector(partyPersonChanged))
        self.startObservingNotification(name: PartyNotification.personRemoved.rawValue,
                                        selector: #selector(partyPersonRemoved))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.nameChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.statusChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.gameNameChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.hostNameChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.personRemoved.rawValue)
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle(self.party.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        
        if self.party.userName == self.party.hostName {
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }
        
        self.setNavigationBarBackgroundColor(Partybox.color.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func leaveButtonPressed() {
        let subject = "Slow down"
        let message = "Are you sure you want to leave?"
        let action = "Leave"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            if self.party.userName == self.party.hostName {
                let rootViewController = ChangePartyHostViewController.construct(store: self.store, party: self.party, delegate: self)
                let navigationController = UINavigationController(rootViewController: rootViewController)
                self.present(navigationController, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: {
                    self.party.leave()
                })
            }
        })
    }
    
    @objc private func manageButtonPressed() {
        let rootViewController = ManagePartyViewController.construct(store: self.store, party: self.party, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions

    @objc private func partyNameChanged() {
        self.setNavigationBarTitle(self.party.name)
    }

    @objc private func partyStatusChanged() {
        if self.party.status == PartyStatus.starting.rawValue {
            //self.showStartWannabeViewController()
        }
    }

    @objc private func partyGameNameChanged() {
        self.contentView.reloadTable()
    }

    @objc private func partyHostNameChanged() {
        if self.party.userName == self.party.hostName {
            let subject = "Woah there"
            let message = "You are the new host of the party\n\nInvite people to join with the invite code"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }

        self.contentView.reloadTable()
    }

    @objc private func partyPersonAdded() {
        self.contentView.reloadTable()
    }

    @objc private func partyPersonChanged() {
        self.contentView.reloadTable()
    }

    @objc private func partyPersonRemoved() {
        self.contentView.reloadTable()

        if !self.party.people.contains(key: self.party.userName) {
            self.dismiss(animated: true, completion: {
                self.delegate.partyViewController(self, userKicked: true)
            })
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {

    internal func partyView(_ view: PartyView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()

        self.store.fetchPacks(gameName: self.party.gameName, callback: {
            (error) in

            self.contentView.stopAnimatingPlayButton()

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            if self.party.gameName == self.party.wannabe.name {
                let rootViewController = SetupWannabeViewController.construct(store: self.store, party: self.party)
                let navigationController = UINavigationController(rootViewController: rootViewController)
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    }
    
    internal func partyView(_ view: PartyView, changeButtonPressed: Bool) {
        let rootViewController = ChangePartyGameViewController.construct(store: self.store, party: self.party, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func partyView(_ view: PartyView, partyPersonKicked partyPersonName: String) {
        let subject = "Woah there"
        let message = "Are you sure you want to kick this person?"
        let action = "Kick"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            self.party.remove(personName: partyPersonName)
        })
    }
    
}

extension PartyViewController: PartyViewDataSource {

    internal func partyViewUserName() -> String {
        return self.party.userName
    }

    internal func partyViewPartyId() -> String {
        return self.party.id
    }

    internal func partyViewPartyHostName() -> String {
        return self.party.hostName
    }

    internal func partyViewPartyPeopleCount() -> Int {
        return self.party.people.count
    }

    internal func partyViewPartyPerson(index: Int) -> PartyPerson? {
        return self.party.people.fetch(index: index)
    }

    internal func partyViewPartyGameName() -> String {
        return self.party.wannabe.name
    }

    internal func partyViewPartyGameSummary() -> String {
        return "Summary"
    }

}

extension PartyViewController: ManagePartyViewControllerDelegate {

    internal func managePartyViewController(_ controller: ManagePartyViewController, partyManaged: Bool) {
        self.contentView.reloadTable()
    }

}

extension PartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, partyHostChanged partyHostName: String) {
        self.party.change(hostName: partyHostName, callback: {
            (error) in

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.dismiss(animated: true, completion: {
                self.party.leave()
            })
        })
    }

}

extension PartyViewController: ChangePartyGameViewControllerDelegate {

    internal func changePartyGameViewController(_ controller: ChangePartyGameViewController, partyGameChanged: Bool) {
        self.contentView.reloadTable()
    }

}
