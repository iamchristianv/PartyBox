//
//  ChangeHostViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangeHostViewController: UIViewController {

    // MARK: - Instance Properties

    private var user: User!

    private var party: Party!
    
    private var contentView: ChangeHostView!
    
    private var delegate: ChangeHostViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(user: User, party: Party, delegate: ChangeHostViewControllerDelegate) -> ChangeHostViewController {
        let controller = ChangeHostViewController()
        controller.user = user
        controller.party = party
        controller.contentView = ChangeHostView.construct(delegate: controller, dataSource: controller)
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
        self.setNavigationBarTitle("Change Host")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc private func partyPeopleChanged() {
//        self.contentView.reloadTable()
//
//        if Party.current.people.person(name: self.contentView.selectedPersonId) == nil {
//            self.contentView.selectedPersonId = Party.current.details.hostName
//            self.contentView.reloadTable()
//        }
    }

}

extension ChangeHostViewController: ChangeHostViewDelegate {
    
    // MARK: - Change Host View Delegate
    
    func changeHostView(_ changeHostView: ChangeHostView, saveChangesButtonPressed: Bool) {
        if self.contentView.hostName() == self.party.details.host {
            let subject = "Woah there"
            let message = "Please select a new person to be the host"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        } else {
            self.delegate.changeHostViewController(self, hostChanged: self.contentView.hostName())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ChangeHostViewController: ChangeHostViewDataSource {

    // MARK: - Change Host View Data Source Functions

    func changeHostViewHostName() -> String {
        return self.party.details.host
    }

    func changeHostViewPeopleCount() -> Int {
        return self.party.people.persons.count
    }

    func changeHostViewPerson(index: Int) -> PartyPerson? {
        return self.party.people.persons.fetch(index: index)
    }

}
