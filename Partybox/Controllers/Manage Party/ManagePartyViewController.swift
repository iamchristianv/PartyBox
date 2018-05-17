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

    private var user: User!

    private var party: Party!

    private var game: Game!
    
    private var contentView: ManagePartyView!

    private var delegate: ManagePartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(user: User, party: Party, game: Game, delegate: ManagePartyViewControllerDelegate) -> ManagePartyViewController {
        let controller = ManagePartyViewController()
        controller.user = user
        controller.party = party
        controller.game = game
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
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }

    // MARK: - Action Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension ManagePartyViewController: ManagePartyViewDelegate {
    
    // MARK: - Manage Party View Delegate Functions

    internal func managePartyView(_ managePartyView: ManagePartyView, partyHostTextFieldPressed: Bool) {
        let changeHostViewController = ChangeHostViewController.construct(user: self.user,
                                                                          party: self.party,
                                                                          delegate: self)
        let navigationController = UINavigationController(rootViewController: changeHostViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func managePartyView(_ managePartyView: ManagePartyView, saveChangesButtonPressed: Bool) {
        self.contentView.startAnimatingSaveChangesButton()

        let name = self.contentView.partyName()
        let host = self.contentView.partyHost()

        let values = [PartyDetailsKey.name.rawValue: name,
                      PartyDetailsKey.hostName.rawValue: host]
        
        self.party.details.update(values: values, callback: {
            (error) in
            
            self.contentView.stopAnimatingSaveChangesButton()
            
            if let error = error {
                let subject = "Oh no"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                self.delegate.managePartyViewController(self, partyManaged: true)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
}

extension ManagePartyViewController: ManagePartyViewDataSource {

    // MARK: - Manage Party Data Source Functions

    internal func managePartyViewPartyName() -> String {
        return self.party.details.name
    }

    internal func managePartyViewPartyHost() -> String {
        return self.party.details.hostName
    }

}

extension ManagePartyViewController: ChangeHostViewControllerDelegate {

    // MARK: - Change Host View Controller Delegate Functions

    internal func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostChanged hostName: String) {
        self.contentView.setPartyHost(hostName: hostName)
    }

}
