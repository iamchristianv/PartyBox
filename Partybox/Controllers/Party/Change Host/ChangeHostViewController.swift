//
//  ChangeHostViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangeHostViewController: UIViewController {

    // MARK: - Instance Properties

    private var session: Session!
    
    private var contentView: ChangeHostView!
    
    private var delegate: ChangeHostViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(session: Session, delegate: ChangeHostViewControllerDelegate) -> ChangeHostViewController {
        let controller = ChangeHostViewController()
        controller.session = session
        controller.contentView = ChangeHostView.construct(delegate: controller, dataSource: controller)
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
        self.startObservingNotification(name: PartyPeopleNotification.personAdded.rawValue,
                                        selector: #selector(partyPeoplePersonAdded))
        self.startObservingNotification(name: PartyPeopleNotification.personChanged.rawValue,
                                        selector: #selector(partyPeoplePersonChanged))
        self.startObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue,
                                        selector: #selector(partyPeoplePersonRemoved))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyPeopleNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyPeopleNotification.personRemoved.rawValue)
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle("Change Host")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc private func partyPeoplePersonAdded(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonChanged(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPeoplePersonRemoved(notification: Notification) {
        self.contentView.reloadTable()

        if !self.session.party.people.persons.contains(key: self.contentView.hostName()) {
            self.contentView.setHostName(self.session.party.details.hostName)
            self.contentView.reloadTable()
        }
    }

}

extension ChangeHostViewController: ChangeHostViewDelegate {
        
    func changeHostView(_ changeHostView: ChangeHostView, saveButtonPressed: Bool) {
        if self.contentView.hostName() == self.session.party.details.hostName {
            let subject = "Woah there"
            let message = "Please select a new person to be the host"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        } else {
            self.delegate.changeHostViewController(self, hostNameChanged: self.contentView.hostName())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ChangeHostViewController: ChangeHostViewDataSource {

    func changeHostViewHostName() -> String {
        return self.session.party.details.hostName
    }

    func changeHostViewPeopleCount() -> Int {
        return self.session.party.people.persons.count
    }

    func changeHostViewPerson(index: Int) -> PartyPerson? {
        return self.session.party.people.persons.fetch(index: index)
    }

}
