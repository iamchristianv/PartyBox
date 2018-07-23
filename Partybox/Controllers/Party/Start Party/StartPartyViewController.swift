//
//  StartPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class StartPartyViewController: UIViewController {
    
    // MARK: - Properties

    private var store: Store

    private var party: Party!

    private var contentView: StartPartyView

    // MARK: - Initialization Functions

    init(store: Store) {
        self.store = store
        self.party = nil
        self.contentView = StartPartyView(delegate: self)
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
        self.setNavigationBarTitle("Start Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.color.red)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension StartPartyViewController: StartPartyViewDelegate {

    internal func startPartyView(_ view: StartPartyView, startButtonPressed: Bool) {
        if self.contentView.needsUserInput() {
            return
        }

        self.party = Party(name: self.contentView.partyName())

        self.contentView.startAnimatingStartButton()

        self.party.initialize(callback: {
            (error) in

            self.contentView.stopAnimatingStartButton()

            if let error = error {
                let subject = "Uh oh"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
                return
            }

            self.contentView.startAnimatingStartButton()

            let person = self.party.createPerson(name: self.contentView.userName())

            self.party.insert(person: person, callback: {
                (error) in

                self.contentView.stopAnimatingStartButton()

                if let error = error {
                    let subject = "Uh oh"
                    let message = error
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                    return
                }

                let viewController = PartyViewController(store: self.store, party: self.party, delegate: self)
                self.show(viewController, sender: nil)
            })
        })
    }

}

extension StartPartyViewController: PartyViewControllerDelegate {

    internal func partyViewController(_ controller: PartyViewController, userKicked: Bool) {
        let subject = "Oh no"
        let message = "You were kicked from the party"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }

}
