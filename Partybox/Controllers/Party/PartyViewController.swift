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

    private var user: User!

    private var party: Party!

    private var game: Game!
    
    private var contentView: PartyView!

    private var delegate: PartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(user: User, party: Party, game: Game, delegate: PartyViewControllerDelegate) -> PartyViewController {
        let controller = PartyViewController()
        controller.user = user
        controller.party = party
        controller.game = game
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
        self.startObservingNotification(name: PartyDetailsNotification.nameChanged.rawValue,
                                        selector: #selector(partyDetailsNameChanged))
        self.startObservingNotification(name: PartyDetailsNotification.gameChanged.rawValue,
                                        selector: #selector(partyDetailsGameChanged))
        self.startObservingNotification(name: PartyDetailsNotification.statusChanged.rawValue,
                                        selector: #selector(partyDetailsStatusChanged))
        self.startObservingNotification(name: PartyDetailsNotification.hostChanged.rawValue,
                                        selector: #selector(partyDetailsHostChanged))
        self.startObservingNotification(name: PartyPeopleNotification.personAdded.rawValue,
                                        selector: #selector(partyPeoplePersonAdded))
        self.startObservingNotification(name: PartyPeopleNotification.personChanged.rawValue,
                                        selector: #selector(partyPeoplePersonChanged))
        self.startObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue,
                                        selector: #selector(partyPeoplePersonRemoved))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyDetailsNotification.nameChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.gameChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.statusChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.hostChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue)
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle(self.party.details.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        
        if self.user.name == self.party.details.host {
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }
        
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func leaveButtonPressed() {
        let subject = "Slow down"
        let message = "Are you sure you want to leave?"
        let action = "Leave"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            if self.party.people.persons.count > 1 {
                if self.user.name == self.party.details.host {
                    let changeHostViewController = ChangeHostViewController.construct(user: self.user,
                                                                                      party: self.party,
                                                                                      delegate: self)
                    let navigationController = UINavigationController(rootViewController: changeHostViewController)
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: {
                        self.party.leave(user: self.user, callback: {
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
                    self.party.end(user: self.user, callback: {
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
        let managePartyViewController = ManagePartyViewController.construct(user: self.user,
                                                                            party: self.party,
                                                                            game: self.game,
                                                                            delegate: self)
        let navigationController = UINavigationController(rootViewController: managePartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions

    @objc private func partyDetailsNameChanged(notification: Notification) {
        self.setNavigationBarTitle(self.party.details.name)
    }

    @objc private func partyDetailsGameChanged(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyDetailsStatusChanged(notification: Notification) {
        if self.party.details.status == PartyDetailsStatus.playing.rawValue {
            //self.showSetupWannabeViewController()
        }
    }

    @objc private func partyDetailsHostChanged(notification: Notification) {
        if self.user.name == self.party.details.host {
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))

            let subject = "Woah there"
            let message = "You are the new host of the party\n\nInvite people to join with the invite code"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }

        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonAdded(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonChanged(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonRemoved(notification: Notification) {
        self.contentView.reloadTable()

        if !self.party.people.persons.contains(key: user.name) {
            self.dismiss(animated: true, completion: {
                self.delegate.partyViewController(self, userKicked: true)
            })
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {

    // MARK: - Party View Delegate Functions
    
    internal func partyView(_ partyView: PartyView, playGameButtonPressed: Bool) {
        self.contentView.startAnimatingPlayGameButton()

        if self.party.details.game == self.game.wannabe.details.id {
            self.game.wannabe.collection.fetchPacks(callback: {
                (error) in

                self.contentView.stopAnimatingPlayGameButton()

                if let error = error {
                    let subject = "Oh no"
                    let message = error
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                } else {
                    //self.showSetupWannabeViewController()
                }
            })
        }
    }
    
    internal func partyView(_ partyView: PartyView, changeGameButtonPressed: Bool) {
        //self.showChangeGameViewController()
    }
    
    internal func partyView(_ partyView: PartyView, kickButtonPressed person: PartyPerson) {
        let subject = "Woah there"
        let message = "Are you sure you want to kick this person?"
        let action = "Kick"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            let values = [person.name: Partybox.null]

            self.party.people.update(values: values, callback: {
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

    // MARK: - Party View Data Source Functions

    internal func partyViewUserName() -> String {
        return self.user.name
    }

    internal func partyViewPartyId() -> String {
        return self.party.details.id
    }

    internal func partyViewHostName() -> String {
        return self.party.details.host
    }

    internal func partyViewPeopleCount() -> Int {
        return self.party.people.persons.count
    }

    internal func partyViewPerson(index: Int) -> PartyPerson? {
        return self.party.people.persons.fetch(index: index)
    }

    internal func partyViewGameName() -> String {
        return self.game.wannabe.details.name
    }

    internal func partyViewGameSummary() -> String {
        return self.game.wannabe.details.summary
    }

}

extension PartyViewController: ManagePartyViewControllerDelegate {

    // MARK: - Manage Party View Controller Delegate Functions

    internal func managePartyViewController(_ managePartyViewController: ManagePartyViewController, partyManaged: Bool) {
        self.contentView.reloadTable()
    }

}

extension PartyViewController: ChangeHostViewControllerDelegate {

    // MARK: - Change Host View Controller Delegate Functions

    internal func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostChanged hostName: String) {
        let values = [PartyDetailsKey.host.rawValue: hostName]

        self.party.details.update(values: values, callback: {
            (error) in

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                self.dismiss(animated: true, completion: {
                    self.party.leave(user: self.user, callback: {
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

}

