//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: UIViewController {

    // MARK: - Properties

    private var store: Store

    private var party: Party

    private var delegate: PartyViewControllerDelegate

    private var contentView: PartyView

    // MARK: - Initialization Functions

    init(store: Store, party: Party, delegate: PartyViewControllerDelegate) {
        self.store = store
        self.party = party
        self.delegate = delegate
        self.contentView = PartyView(delegate: self, dataSource: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.startObservingNotification(name: PartyNotification.gameIdChanged.rawValue,
                                        selector: #selector(partyGameIdChanged))
        self.startObservingNotification(name: PartyNotification.personAdded.rawValue,
                                        selector: #selector(partyPersonAdded))
        self.startObservingNotification(name: PartyNotification.personChanged.rawValue,
                                        selector: #selector(partyPersonChanged))
        self.startObservingNotification(name: PartyNotification.personRemoved.rawValue,
                                        selector: #selector(partyPersonRemoved))
        self.startObservingNotification(name: PartyNotification.wannabeStarted.rawValue,
                                        selector: #selector(partyWannabeStarted))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.nameChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.hostIdChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.gameIdChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.personRemoved.rawValue)
        self.stopObservingNotification(name: PartyNotification.wannabeStarted.rawValue)
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
            if self.party.persons.count > 1 {
                if self.party.userId == self.party.hostId {
                    let rootViewController = ChangePartyHostViewController(store: self.store, party: self.party, delegate: self)
                    let navigationController = UINavigationController(rootViewController: rootViewController)
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: {
                        guard let person = self.party.persons[self.party.userId] else {
                            return
                        }

                        self.party.remove(person: person, callback: {
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
            } else {
                self.dismiss(animated: true, completion: {
                    self.party.terminate(callback: {
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
        })
    }
    
    @objc private func manageButtonPressed() {
        let rootViewController = ManagePartyViewController(store: self.store, party: self.party, delegate: self)
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

    @objc private func partyGameIdChanged() {
        self.contentView.reloadTable()
    }

    @objc private func partyPersonAdded() {
        self.contentView.reloadTable()
    }

    @objc private func partyPersonChanged() {
        self.contentView.reloadTable()

        guard let person = self.party.persons[self.party.userId] else {
            return
        }

        if person.points == -1 {
            self.dismiss(animated: true, completion: {
                self.party.remove(person: person, callback: {
                    (error) in

                    if let error = error {
                        let subject = "Oh no"
                        let message = error
                        let action = "Okay"
                        self.showAlert(subject: subject, message: message, action: action, handler: nil)
                        return
                    }

                    self.delegate.partyViewController(self, userKicked: true)
                })
            })
        }
    }

    @objc private func partyPersonRemoved() {
        self.contentView.reloadTable()
    }

    @objc private func partyWannabeStarted() {
        let rootViewController = StartWannabeViewController.construct(store: self.store, party: self.party)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

extension PartyViewController: PartyViewDelegate {

    internal func partyView(_ view: PartyView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()

        self.store.fetchTitles(gameId: self.party.gameId, callback: {
            (error) in

            self.contentView.stopAnimatingPlayButton()

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            if self.party.gameId == self.store.wannabe.id {
                let rootViewController = SetupWannabeViewController.construct(store: self.store, party: self.party)
                let navigationController = UINavigationController(rootViewController: rootViewController)
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    }
    
    internal func partyView(_ view: PartyView, changeButtonPressed: Bool) {
        let rootViewController = ChangePartyGameViewController(store: self.store, party: self.party, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func partyView(_ view: PartyView, personKicked personId: String) {
        let subject = "Woah there"
        let message = "Are you sure you want to kick this person?"
        let action = "Kick"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            let path = "\(PartyboxKey.parties.rawValue)/\(self.party.id)/\(PartyKey.persons.rawValue)/\(personId)"

            let values = [PartyPersonKey.points.rawValue: -1]

            self.party.update(path: path, values: values, callback: {
                (error) in

                if let error = error {
                    let subject = "Oh no"
                    let message = error
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                    return
                }
            })
        })
    }
    
}

extension PartyViewController: PartyViewDataSource {

    internal func partyViewPartyId() -> String {
        return self.party.id
    }

    internal func partyViewPartyUserId() -> String {
        return self.party.userId
    }

    internal func partyViewPartyHostId() -> String {
        return self.party.hostId
    }

    internal func partyViewPartyPersonsCount() -> Int {
        return self.party.persons.count
    }

    internal func partyViewPartyPersonId(index: Int) -> String {
        guard let person = self.party.persons[index] else {
            return Partybox.value.none
        }

        return person.id
    }

    internal func partyViewPartyPersonName(index: Int) -> String {
        guard let person = self.party.persons[index] else {
            return Partybox.value.none
        }

        return person.name
    }

    internal func partyViewPartyPersonPoints(index: Int) -> Int {
        guard let person = self.party.persons[index] else {
            return Partybox.value.zero
        }

        return person.points
    }

    internal func partyViewGameName() -> String {
        if self.party.gameId == self.store.wannabe.id {
            return self.store.wannabe.name
        }

        return Partybox.value.none
    }

    internal func partyViewGameSummary() -> String {
        if self.party.gameId == self.store.wannabe.id {
            return self.store.wannabe.summary
        }

        return Partybox.value.none
    }

}

extension PartyViewController: ManagePartyViewControllerDelegate {

    internal func managePartyViewController(_ controller: ManagePartyViewController, partyManaged: Bool) {
        self.contentView.reloadTable()
    }

}

extension PartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, hostChanged hostId: String) {
        let path = "\(PartyboxKey.parties.rawValue)/\(self.party.id)"

        let values = [PartyKey.hostId.rawValue: hostId]

        self.party.update(path: path, values: values, callback: {
            (error) in

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.dismiss(animated: true, completion: {
                guard let person = self.party.persons[self.party.userId] else {
                    return
                }

                self.party.remove(person: person, callback: {
                    (error) in

                    if let error = error {
                        let subject = "Oh no"
                        let message = error
                        let action = "Okay"
                        self.showAlert(subject: subject, message: message, action: action, handler: nil)
                        return
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
