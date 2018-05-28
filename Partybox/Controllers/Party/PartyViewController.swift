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

    private var session: Session!
    
    private var contentView: PartyView!

    private var delegate: PartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(session: Session, delegate: PartyViewControllerDelegate) -> PartyViewController {
        let controller = PartyViewController()
        controller.session = session
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
        self.startObservingNotification(name: PartyDetailsNotification.statusChanged.rawValue,
                                        selector: #selector(partyDetailsStatusChanged))
        self.startObservingNotification(name: PartyDetailsNotification.gameIdChanged.rawValue,
                                        selector: #selector(partyDetailsGameIdChanged))
        self.startObservingNotification(name: PartyDetailsNotification.hostNameChanged.rawValue,
                                        selector: #selector(partyDetailsHostNameChanged))
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
        self.stopObservingNotification(name: PartyDetailsNotification.statusChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.gameIdChanged.rawValue)
        self.stopObservingNotification(name: PartyDetailsNotification.hostNameChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue)
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle(self.session.party.details.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        
        if self.session.user.name == self.session.party.details.hostName {
            self.setNavigationBarRightButton(title: "manage", target: self, action: #selector(manageButtonPressed))
        } else {
            self.setNavigationBarRightButton(title: nil, target: nil, action: nil)
        }
        
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func leaveButtonPressed() {
        let subject = "Slow down"
        let message = "Are you sure you want to leave?"
        let action = "Leave"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            if self.session.party.people.persons.count > 1 {
                if self.session.user.name == self.session.party.details.hostName {
                    let changeHostViewController = ChangeHostViewController.construct(session: self.session, delegate: self)
                    let navigationController = UINavigationController(rootViewController: changeHostViewController)
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: {
                        self.session.party.leave()
                    })
                }
            } else {
                self.dismiss(animated: true, completion: {
                    self.session.party.end()
                })
            }
        })
    }
    
    @objc private func manageButtonPressed() {
        let managePartyViewController = ManagePartyViewController.construct(session: self.session, delegate: self)
        let navigationController = UINavigationController(rootViewController: managePartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions

    @objc private func partyDetailsNameChanged(notification: Notification) {
        self.setNavigationBarTitle(self.session.party.details.name)
    }

    @objc private func partyDetailsStatusChanged(notification: Notification) {
        if self.session.party.details.status == PartyDetailsStatus.playing.rawValue {
            //self.showSetupWannabeViewController()
        }
    }

    @objc private func partyDetailsGameIdChanged(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyDetailsHostNameChanged(notification: Notification) {
        if self.session.user.name == self.session.party.details.hostName {
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

        if !self.session.party.people.persons.contains(key: self.session.user.name) {
            self.dismiss(animated: true, completion: {
                self.delegate.partyViewController(self, userKicked: true)
            })
        }
    }
    
}

extension PartyViewController: PartyViewDelegate {

    internal func partyView(_ partyView: PartyView, playButtonPressed: Bool) {
        self.contentView.startAnimatingPlayButton()

        self.session.fetchPacks(callback: {
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
    
    internal func partyView(_ partyView: PartyView, changeButtonPressed: Bool) {
        let changeGameViewController = ChangeGameViewController.construct(session: self.session, delegate: self)
        let navigationController = UINavigationController(rootViewController: changeGameViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func partyView(_ partyView: PartyView, kickButtonPressed personName: String) {
        let subject = "Woah there"
        let message = "Are you sure you want to kick this person?"
        let action = "Kick"
        self.showAlert(subject: subject, message: message, action: action, handler: {
            let values = [personName: Partybox.values.null]

            self.session.party.people.update(values: values, callback: {
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

    internal func partyViewUserName() -> String {
        return self.session.user.name
    }

    internal func partyViewPartyId() -> String {
        return self.session.party.details.id
    }

    internal func partyViewHostName() -> String {
        return self.session.party.details.hostName
    }

    internal func partyViewPeopleCount() -> Int {
        return self.session.party.people.persons.count
    }

    internal func partyViewPerson(index: Int) -> PartyPerson? {
        return self.session.party.people.persons.fetch(index: index)
    }

    internal func partyViewGameName() -> String {
        return self.session.wannabe.details.name
    }

    internal func partyViewGameSummary() -> String {
        return self.session.wannabe.manual.summary
    }

}

extension PartyViewController: ManagePartyViewControllerDelegate {

    internal func managePartyViewController(_ managePartyViewController: ManagePartyViewController, partyManaged: Bool) {
        self.contentView.reloadTable()
    }

}

extension PartyViewController: ChangeHostViewControllerDelegate {

    internal func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostNameChanged hostName: String) {
        let values = [PartyDetailsKey.hostName.rawValue: hostName]

        self.session.party.details.update(values: values, callback: {
            (error) in

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                self.dismiss(animated: true, completion: {
                    self.session.party.leave()
                })
            }
        })
    }

}

extension PartyViewController: ChangeGameViewControllerDelegate {

    func changeGameViewController(_ changeGameViewController: ChangeGameViewController, gameChanged: Bool) {
        self.contentView.reloadTable()
    }

}
