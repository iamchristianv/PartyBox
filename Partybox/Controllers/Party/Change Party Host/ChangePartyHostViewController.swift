//
//  ChangePartyHostViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangePartyHostViewController: UIViewController {

    // MARK: - Model Properties

    private var store: Store!

    private var party: Party!

    // MARK: - Controller Properties

    private var partyHostId: String!

    private var delegate: ChangePartyHostViewControllerDelegate!

    // MARK: - View Properties
    
    private var contentView: ChangePartyHostView!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ChangePartyHostViewControllerDelegate) -> ChangePartyHostViewController {
        let controller = ChangePartyHostViewController()
        // Model Properties
        controller.store = store
        controller.party = party
        // Controller Properties
        controller.partyHostId = party.hostId
        controller.delegate = delegate
        // View Properties
        controller.contentView = ChangePartyHostView.construct(delegate: controller, dataSource: controller)
        return controller
    }
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.startObservingNotification(name: PartyNotification.guestAdded.rawValue,
                                        selector: #selector(partyGuestAdded))
        self.startObservingNotification(name: PartyNotification.guestChanged.rawValue,
                                        selector: #selector(partyGuestChanged))
        self.startObservingNotification(name: PartyNotification.guestRemoved.rawValue,
                                        selector: #selector(partyGuestRemoved))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.guestAdded.rawValue)
        self.stopObservingNotification(name: PartyNotification.guestChanged.rawValue)
        self.stopObservingNotification(name: PartyNotification.guestRemoved.rawValue)
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

        if self.party.guests[self.partyHostId] == nil {
            self.contentView.reloadTable()
        }
    }

}

extension ChangePartyHostViewController: ChangePartyHostViewDelegate {

    func changePartyHostView(_ view: ChangePartyHostView, guestSelected guestId: String) {
        self.partyHostId = guestId
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
        guard let partyHostId = self.partyHostId else {
            return Partybox.value.none
        }

        return partyHostId
    }

    func changePartyHostViewPartyGuestsCount() -> Int {
        return self.party.guests.count
    }

    func changePartyHostViewPartyGuest(index: Int) -> PartyGuest {
        guard let guest = self.party.guests[index] else {
            return PartyGuest()
        }

        return guest
    }

}
