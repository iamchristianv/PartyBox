//
//  ManagePartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyViewController: UIViewController {

    // MARK: - Properties

    private var store: Store

    private var party: Party

    private var partyName: String

    private var partyHostId: String

    private var delegate: ManagePartyViewControllerDelegate

    private var contentView: ManagePartyView

    // MARK: - Initialization Functions

    init(store: Store, party: Party, delegate: ManagePartyViewControllerDelegate) {
        self.store = store
        self.party = party
        self.partyName = party.name
        self.partyHostId = party.hostId
        self.delegate = delegate
        self.contentView = ManagePartyView(delegate: self, dataSource: self)
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
        let rootViewController = ChangePartyHostViewController(store: self.store, party: self.party, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func managePartyView(_ view: ManagePartyView, saveButtonPressed: Bool) {
        if self.contentView.needsUserInput() {
            return
        }

        self.partyName = self.contentView.partyName()

        self.contentView.startAnimatingSaveButton()

        let path = "\(PartyboxKey.parties.rawValue)/\(self.party.id)"

        let values = [
            PartyKey.name.rawValue: self.partyName,
            PartyKey.hostId.rawValue: self.partyHostId
        ] as [String: Any]

        self.party.update(path: path, values: values, callback: {
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
        return self.partyName
    }

    internal func managePartyViewPartyHostName() -> String {
        guard let person = self.party.persons[self.partyHostId] else {
            return Partybox.value.none
        }

        return person.name
    }

}

extension ManagePartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, hostChanged hostId: String) {
        guard let person = self.party.persons[hostId] else {
            return
        }

        self.partyHostId = hostId
        self.contentView.setPartyHostName(person.name)
    }

}
