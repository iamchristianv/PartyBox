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

    private var user: User!

    private var party: Party!

    private var game: Game!
    
    private var contentView: PartyView!

    var gameDetailsStatusChangedNotificationName: String!

    var delegate: PartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(user: User, party: Party, game: Game, delegate: PartyViewControllerDelegate) -> PartyViewController {
        let controller = PartyViewController()
        controller.user = user
        controller.party = party
        controller.game = game
        controller.contentView = PartyView.construct(delegate: controller, dataSource: controller)
        controller.gameDetailsStatusChangedNotificationName = nil
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
        self.startObservingNotification(name: PartyDetailsNotification.hostChanged.rawValue,
                                        selector: #selector(partyDetailsHostChanged))
        self.startObservingNotification(name: PartyDetailsNotification.gameChanged.rawValue,
                                        selector: #selector(partyDetailsGameChanged))
        self.startObservingNotification(name: PartyPeopleNotification.personAdded.rawValue,
                                        selector: #selector(partyPeoplePersonAdded))
        self.startObservingNotification(name: PartyPeopleNotification.personChanged.rawValue,
                                        selector: #selector(partyPeoplePersonChanged))
        self.startObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue,
                                        selector: #selector(partyPeoplePersonRemoved))
        self.startObservingGameDetailsStatusChangedNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyDetailsNotification.nameChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.hostChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.gameChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue)
        self.stopObservingGameDetailsStatusChangedNotification()
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
            if self.user.name == self.party.details.host && self.party.people.persons.count > 1 {
                //self.showChangeHostViewController(delegate: self)
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
        //self.showManagePartyViewController()
    }
    
    // MARK: - Notification Functions

    @objc private func partyDetailsNameChanged(notification: Notification) {
        self.setNavigationBarTitle(self.party.details.name)
    }

    @objc private func partyDetailsHostChanged(notification: Notification) {
        self.contentView.reloadTable()

        if self.user.name == self.party.details.host {
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))

            let subject = "Woah there"
            let message = "You are the new host of the party"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }
    }

    @objc private func partyDetailsGameChanged(notification: Notification) {
        self.contentView.reloadTable()

        self.stopObservingGameDetailsStatusChangedNotification()
        self.startObservingGameDetailsStatusChangedNotification()
    }

    @objc private func partyPeoplePersonAdded(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonChanged(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonRemoved(notification: Notification) {
        self.contentView.reloadTable()

        if self.party.people.persons.contains(PartyPerson.construct(name: self.user.name)) {
            self.dismiss(animated: true, completion: {
                self.delegate.partyViewController(self, userKicked: true)
            })
        }
    }
    
    @objc private func gameDetailsStatusChanged() {
        if self.party.details.game == self.game.wannabe.details.id {
            if self.game.wannabe.details.status == WannabeDetailsStatus.starting.rawValue {
                //self.showStartWannabeViewController()
            }
        }
    }

    private func startObservingGameDetailsStatusChangedNotification() {
        if self.party.details.game == self.game.wannabe.details.id {
            self.gameDetailsStatusChangedNotificationName = WannabeDetailsNotification.statusChanged.rawValue
        }

        self.startObservingNotification(name: self.gameDetailsStatusChangedNotificationName,
                                        selector: #selector(gameDetailsStatusChanged))
    }

    private func stopObservingGameDetailsStatusChangedNotification() {
        self.stopObservingNotification(name: self.gameDetailsStatusChangedNotificationName)
    }
    
}

extension PartyViewController: PartyViewDelegate {

    // MARK: - Party View Delegate Functions
    
    func partyView(_ partyView: PartyView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()

        if self.party.details.game == self.game.wannabe.details.id {
            self.game.wannabe.collection.fetchPacks(callback: {
                (error) in

                self.contentView.stopAnimatingPlayButton()

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
    
    func partyView(_ partyView: PartyView, changeButtonPressed: Bool) {
        //self.showChangeGameViewController()
    }
    
    func partyView(_ partyView: PartyView, kickButtonPressed person: PartyPerson) {
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

    func partyViewUserName() -> String {
        return self.user.name
    }

    func partyViewPartyHost() -> String {
        return self.party.details.host
    }

    func partyViewPartyPerson(index: Int) -> PartyPerson? {
        return self.party.people.persons.fetch(index: index)
    }

    func partyViewPartyPeopleCount() -> Int {
        return self.party.people.persons.count
    }

    func partyViewPartyId() -> String {
        return self.party.details.id
    }

    func partyViewPartyGameName() -> String {
        return self.game.wannabe.details.name
    }

    func partyViewPartyGameSummary() -> String {
        return self.game.wannabe.manual.summary
    }

}

//extension PartyViewController: ChangeHostViewControllerDelegate {
//    
//    // MARK: - Change Host View Controller Delegate Functions
//    
//    func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostChanged: Bool) {
//        self.dismissViewController(animated: true, completion: {
//            Party.current.end()
//        })
//    }
//    
//}

