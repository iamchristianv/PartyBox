//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: UIViewController {

    // MARK: - Model Properties

    private var store: Store!

    private var party: Party!

    // MARK: - View Properties
    
    private var contentView: PartyView!

    // MARK: - Controller Properties

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
        self.startObservingNotification(name: PartyNotification.hostIdChanged.rawValue,
                                        selector: #selector(partyHostIdChanged))
        self.startObservingNotification(name: PartyNotification.guestAdded.rawValue,
                                        selector: #selector(partyGuestAdded))
        self.startObservingNotification(name: PartyNotification.guestChanged.rawValue,
                                        selector: #selector(partyGuestChanged))
        self.startObservingNotification(name: PartyNotification.guestRemoved.rawValue,
                                        selector: #selector(partyGuestRemoved))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.nameChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.hostIdChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.guestAdded.rawValue)
        self.stopObservingNotification(name: PartyNotification.guestChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.guestRemoved.rawValue)
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle(self.party.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        
        if self.party.userId == self.party.hostId {
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
            if self.party.userId == self.party.hostId {
                let rootViewController = ChangePartyHostViewController.construct(store: self.store, party: self.party, delegate: self)
                let navigationController = UINavigationController(rootViewController: rootViewController)
                self.present(navigationController, animated: true, completion: nil)
                return
            }

            if self.party.guests.count > 1 {
                self.dismiss(animated: true, completion: {
                    self.party.exit(callback: {
                        (error) in

                        if let error = error {
                            let subject = "Oh no"
                            let message = error
                            let action = "Okay"
                            self.showAlert(subject: subject, message: message, action: action, handler: nil)
                        }
                    })
                })
                return
            }

            if self.party.guests.count == 1 {
                self.dismiss(animated: true, completion: {
                    self.party.end(callback: {
                        (error) in

                        if let error = error {
                            let subject = "Oh no"
                            let message = error
                            let action = "Okay"
                            self.showAlert(subject: subject, message: message, action: action, handler: nil)
                        }
                    })
                })
                return
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

    @objc private func partyHostIdChanged() {
        if self.party.userId == self.party.hostId {
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

    @objc private func partyGuestAdded() {
        self.contentView.reloadTable()
    }

    @objc private func partyGuestChanged() {
        self.contentView.reloadTable()
    }

    @objc private func partyGuestRemoved() {
        self.contentView.reloadTable()

        if self.party.guests[self.party.userId] == nil {
            self.dismiss(animated: true, completion: {
                self.delegate.partyViewController(self, userKicked: true)
            })
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {

    internal func partyView(_ view: PartyView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()

        self.store.fetchNames(gameId: self.party.game.id, callback: {
            (error) in

            self.contentView.stopAnimatingPlayButton()

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            if self.party.game.id == PartyGame.wannabeId {
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
    
    internal func partyView(_ view: PartyView, guestKicked guestId: String) {
        let subject = "Woah there"
        let message = "Are you sure you want to kick this person?"
        let action = "Kick"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            self.party.remove(guestId: guestId, callback: {
                (error) in

                if let error = error {
                    let subject = "Oh no"
                    let message = error
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                }
            })
        })
    }
    
}

extension PartyViewController: PartyViewDataSource {

    internal func partyViewPartyId() -> String {
        return self.party.id
    }

    internal func partyViewPartyHostId() -> String {
        return self.party.hostId
    }

    internal func partyViewPartyGuestsCount() -> Int {
        return self.party.guests.count
    }

    internal func partyViewPartyGuest(index: Int) -> PartyGuest? {
        return self.party.guests[index]
    }

    internal func partyViewPartyGameName() -> String {
        if self.party.game.id == PartyGame.wannabeId {
            let wannabe = self.party.game as! Wannabe
            return wannabe.name
        }

        return Partybox.value.none
    }

    internal func partyViewPartyGameSummary() -> String {
        if self.party.game.id == PartyGame.wannabeId {
            let wannabe = self.party.game as! Wannabe
            return wannabe.summary
        }

        return Partybox.value.none
    }

    internal func partyViewPartyUserId() -> String {
        return self.party.userId
    }

}

extension PartyViewController: ManagePartyViewControllerDelegate {

    internal func managePartyViewController(_ controller: ManagePartyViewController, partyManaged: Bool) {
        self.contentView.reloadTable()
    }

}

extension PartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, hostChanged hostId: String) {
        self.party.change(hostId: hostId, callback: {
            (error) in

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.dismiss(animated: true, completion: {
                self.party.exit(callback: {
                    (error) in

                    if let error = error {
                        let subject = "Oh no"
                        let message = error
                        let action = "Okay"
                        self.showAlert(subject: subject, message: message, action: action, handler: nil)
                    }
                })
            })
        })
    }

}

extension PartyViewController: ChangePartyGameViewControllerDelegate {

    internal func changePartyGameViewController(_ controller: ChangePartyGameViewController, gameChanged: Bool) {
        self.contentView.reloadTable()
    }

}
