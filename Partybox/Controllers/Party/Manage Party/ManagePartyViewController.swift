//
//  ManagePartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyViewController: UIViewController {

    // MARK: - Model Properties

    private var store: Store!

    private var party: Party!

    // MARK: - Controller Properties

    private var partyName: String!

    private var partyHostId: String!

    private var delegate: ManagePartyViewControllerDelegate!

    // MARK: - View Properties
    
    private var contentView: ManagePartyView!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ManagePartyViewControllerDelegate) -> ManagePartyViewController {
        let controller = ManagePartyViewController()
        // Model Properties
        controller.store = store
        controller.party = party
        // Controller Properties
        controller.partyName = party.name
        controller.partyHostId = party.hostId
        controller.delegate = delegate
        // View Properties
        controller.contentView = ManagePartyView.construct(delegate: controller, dataSource: controller)
        return controller
    }
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle("Manage Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.color.green)
    }

    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ManagePartyViewController: ManagePartyViewDelegate {

    internal func managePartyView(_ view: ManagePartyView, partyHostNameTextFieldPressed: Bool) {
        let rootViewController = ChangePartyHostViewController.construct(store: self.store, party: self.party, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func managePartyView(_ view: ManagePartyView, saveButtonPressed: Bool) {
        if self.contentView.needsUserInput() {
            return
        }

        self.partyName = self.contentView.partyName()

        self.contentView.startAnimatingSaveButton()

        self.party.change(name: self.partyName, hostId: self.partyHostId, callback: {
            (error) in

            self.contentView.stopAnimatingSaveButton()

            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.delegate.managePartyViewController(self, partyManaged: true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}

extension ManagePartyViewController: ManagePartyViewDataSource {

    internal func managePartyViewPartyName() -> String {
        guard let partyName = self.partyName else {
            return Partybox.value.none
        }

        return partyName
    }

    internal func managePartyViewPartyHostName() -> String {
        guard let partyHostId = self.partyHostId, let guest = self.party.guests[partyHostId] else {
            return Partybox.value.none
        }

        return guest.name
    }

}

extension ManagePartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, hostChanged hostId: String) {
        guard let guest = self.party.guests[hostId] else {
            return
        }

        self.partyHostId = hostId
        self.contentView.setPartyHostName(guest.name)
    }

}
