//
//  ManagePartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyViewController: UIViewController {

    // MARK: - Instance Properties

    private var store: Store!

    private var party: Party!
    
    private var contentView: ManagePartyView!

    private var delegate: ManagePartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(store: Store, party: Party, delegate: ManagePartyViewControllerDelegate) -> ManagePartyViewController {
        let controller = ManagePartyViewController()
        controller.store = store
        controller.party = party
        controller.contentView = ManagePartyView.construct(delegate: controller, dataSource: controller)
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

    // MARK: - Action Functions
    
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
        let partyNameHasErrors = self.contentView.partyNameHasErrors()

        if partyNameHasErrors {
            return
        }

        self.contentView.startAnimatingSaveButton()

        self.party.change(name: self.contentView.partyName(), hostName: self.contentView.partyHostName(), callback: {
            (error) in

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
        return self.party.name
    }

    internal func managePartyViewPartyHostName() -> String {
        return self.party.hostName
    }

}

extension ManagePartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, partyHostChanged partyHostName: String) {
        self.contentView.setPartyHostName(partyHostName)
    }

}
