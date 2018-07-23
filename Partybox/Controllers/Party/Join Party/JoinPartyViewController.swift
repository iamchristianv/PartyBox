//
//  JoinPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class JoinPartyViewController: UIViewController {

    // MARK: - Properties

    private var store: Store

    private var party: Party!

    private var contentView: JoinPartyView

    // MARK: - Initialization Functions

    init(store: Store) {
        self.store = store
        self.party = nil
        self.contentView = JoinPartyView(delegate: self)
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
        self.setNavigationBarTitle("Join Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.color.blue)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension JoinPartyViewController: JoinPartyViewDelegate {

    internal func joinPartyView(_ view: JoinPartyView, joinButtonPressed: Bool) {
        if self.contentView.needsUserInput() {
            return
        }

        self.party = Party(id: self.contentView.partyId())

        self.contentView.startAnimatingJoinButton()

        let person = self.party.createPerson(name: self.contentView.userName())

        self.party.insert(person: person, callback: {
            (error) in

            self.contentView.stopAnimatingJoinButton()

            if let error = error {
                let subject = "Uh oh"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            let viewController = PartyViewController.construct(store: self.store, party: self.party, delegate: self)
            self.show(viewController, sender: nil)
        })
    }
    
}

extension JoinPartyViewController: PartyViewControllerDelegate {

    internal func partyViewController(_ controller: PartyViewController, userKicked: Bool) {
        let subject = "Oh no"
        let message = "You were kicked from the party"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }

}
