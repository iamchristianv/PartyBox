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

    private var session: Session!
    
    private var contentView: ManagePartyView!

    private var delegate: ManagePartyViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(session: Session, delegate: ManagePartyViewControllerDelegate) -> ManagePartyViewController {
        let controller = ManagePartyViewController()
        controller.session = session
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

    internal func managePartyView(_ managePartyView: ManagePartyView, partyHostNameTextFieldPressed: Bool) {
        let changePartyHostViewController = ChangePartyHostViewController.construct(session: self.session, delegate: self)
        let navigationController = UINavigationController(rootViewController: changePartyHostViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func managePartyView(_ managePartyView: ManagePartyView, saveButtonPressed: Bool) {
        self.contentView.startAnimatingSaveButton()
        
        let values = [PartyDetailsKey.name.rawValue: self.contentView.partyName(),
                      PartyDetailsKey.hostName.rawValue: self.contentView.partyHostName()]
        
        self.session.party.details.update(values: values, callback: {
            (error) in
            
            self.contentView.stopAnimatingSaveButton()
            
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

    internal func managePartyViewPartyName() -> String {
        return self.session.party.details.name
    }

    internal func managePartyViewPartyHostName() -> String {
        return self.session.party.details.hostName
    }

}

extension ManagePartyViewController: ChangePartyHostViewControllerDelegate {

    internal func changePartyHostViewController(_ controller: ChangePartyHostViewController, partyHostChanged partyHostName: String) {
        self.contentView.setPartyHostName(partyHostName)
    }

}
