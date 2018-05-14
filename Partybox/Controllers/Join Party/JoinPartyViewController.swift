//
//  JoinPartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class JoinPartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    private var contentView: JoinPartyView!

    // MARK: - Construction Functions

    static func construct() -> JoinPartyViewController {
        let controller = JoinPartyViewController()
        controller.contentView = JoinPartyView.construct(delegate: controller)
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
        self.setNavigationBarTitle("Join Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.blue)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension JoinPartyViewController: JoinPartyViewDelegate {
    
    // MARK: - Join Party View Delegate Functions
    
    internal func joinPartyView(_ joinPartyView: JoinPartyView, joinPartyButtonPressed: Bool) {
        self.contentView.startAnimatingJoinPartyButton()

        let partyId = self.contentView.partyId()
        let userName = self.contentView.userName()

        let user = User.construct(name: userName)
        let party = Party.construct(id: partyId)
        let game = Game.construct(party: party.details.id)

        party.join(user: user, callback: {
            (error) in

            self.contentView.stopAnimatingJoinPartyButton()

            if let error = error {
                let subject = "Uh oh"
                let message = error
                let action = "Okay"
                self.showAlert(subject: subject, message: message, action: action, handler: nil)
            } else {
                let partyViewController = PartyViewController.construct(user: user,
                                                                        party: party,
                                                                        game: game,
                                                                        delegate: self)
                let navigationController = UINavigationController(rootViewController: partyViewController)
                self.present(navigationController, animated: true, completion: nil)
            }
        })
    }
    
}

extension JoinPartyViewController: PartyViewControllerDelegate {

    // MARK: - Party View Controller Delegate Functions

    internal func partyViewController(_ partyViewController: PartyViewController, userKicked: Bool) {
        let subject = "Oh no"
        let message = "You were kicked from the party"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }

}

