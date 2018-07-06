//
//  ChangePartyHostViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyHostViewController: UIViewController {

    // MARK: - Instance Properties

    private var store: Store!

    private var party: Party!
    
    private var contentView: ChangePartyHostView!
    
    private var delegate: ChangePartyHostViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ChangePartyHostViewControllerDelegate) -> ChangePartyHostViewController {
        let controller = ChangePartyHostViewController()
        controller.store = store
        controller.party = party
        controller.contentView = ChangePartyHostView.construct(delegate: controller, dataSource: controller)
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
        self.startObservingNotification(name: PartyNotification.personAdded.rawValue,
                                        selector: #selector(partyPersonAdded))
        self.startObservingNotification(name: PartyNotification.personChanged.rawValue,
                                        selector: #selector(partyPersonChanged))
        self.startObservingNotification(name: PartyNotification.personRemoved.rawValue,
                                        selector: #selector(partyPersonRemoved))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.personAdded.rawValue)
        self.stopObservingNotification(name: PartyNotification.personChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.personRemoved.rawValue)
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle("Change Host")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.color.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc private func partyPersonAdded(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPersonChanged(notification: Notification) {
        self.contentView.reloadTable()
    }

    @objc private func partyPersonRemoved(notification: Notification) {
        self.contentView.reloadTable()

        if !self.party.people.contains(key: self.contentView.partyHostName()) {
            self.contentView.setPartyHostName(self.party.hostName)
            self.contentView.reloadTable()
        }
    }

}

extension ChangePartyHostViewController: ChangePartyHostViewDelegate {
        
    func changePartyHostView(_ view: ChangePartyHostView, saveButtonPressed: Bool) {
        if self.contentView.partyHostName() == self.party.hostName {
            let subject = "Woah there"
            let message = "Please select a new person to be the host"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
            return
        }

        self.delegate.changePartyHostViewController(self, partyHostChanged: self.contentView.partyHostName())
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChangePartyHostViewController: ChangePartyHostViewDataSource {

    func changePartyHostViewPartyHostName() -> String {
        return self.party.hostName
    }

    func changePartyHostViewPartyPeopleCount() -> Int {
        return self.party.people.count
    }

    func changePartyHostViewPartyPerson(index: Int) -> PartyPerson? {
        return self.party.people.fetch(index: index)
    }

}
