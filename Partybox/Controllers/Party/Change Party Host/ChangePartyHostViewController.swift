//
//  ChangePartyHostViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyHostViewController: UIViewController {

    // MARK: - Properties

    private var store: Store

    private var party: Party

    private var partyHostId: String

    private var delegate: ChangePartyHostViewControllerDelegate

    private var contentView: ChangePartyHostView

    // MARK: - Initialization Functions

    init(store: Store, party: Party, delegate: ChangePartyHostViewControllerDelegate) {
        self.store = store
        self.party = party
        self.partyHostId = party.hostId
        self.delegate = delegate
        self.contentView = ChangePartyHostView(delegate: self, dataSource: self)
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
        self.startObservingNotification(name: PartyNotification.personAdded.rawValue,
                                        selector: #selector(partyGuestAdded))
        self.startObservingNotification(name: PartyNotification.personChanged.rawValue,
                                        selector: #selector(partyGuestChanged))
        self.startObservingNotification(name: PartyNotification.personRemoved.rawValue,
                                        selector: #selector(partyGuestRemoved))
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
    
    @objc private func partyGuestAdded() {
        self.contentView.reloadTable()
    }

    @objc private func partyGuestChanged() {
        self.contentView.reloadTable()
    }

    @objc private func partyGuestRemoved() {
        self.contentView.reloadTable()

        if self.party.persons[self.partyHostId] == nil {
            self.contentView.reloadTable()
        }
    }

}

extension ChangePartyHostViewController: ChangePartyHostViewDelegate {

    func changePartyHostView(_ view: ChangePartyHostView, personSelected personId: String) {
        self.partyHostId = personId
        self.contentView.reloadTable()
    }

    func changePartyHostView(_ view: ChangePartyHostView, saveButtonPressed: Bool) {
        if self.partyHostId == self.party.hostId {
            let subject = "Woah there"
            let message = "Please select a new person to be the host"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
            return
        }

        self.delegate.changePartyHostViewController(self, hostChanged: partyHostId)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChangePartyHostViewController: ChangePartyHostViewDataSource {

    func changePartyHostViewPartyHostId() -> String {
        return self.party.hostId
    }

    func changePartyHostViewPartyPersonsCount() -> Int {
        return self.party.persons.count
    }

    func changePartyHostViewPartyPersonId(index: Int) -> String {
        guard let person = self.party.persons[index] else {
            return Partybox.value.none
        }

        return person.id
    }

    func changePartyHostViewPartyPersonName(index: Int) -> String {
        guard let person = self.party.persons[index] else {
            return Partybox.value.none
        }

        return person.name
    }

}
