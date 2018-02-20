//
//  ChangeHostViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

protocol ChangeHostViewControllerDelegate {
    
    // MARK: - Change Host View Controller Delegate Functions
    
    func changeHostViewController(_ changeHostViewController: ChangeHostViewController, hostChanged: Bool)
    
}

class ChangeHostViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: ChangeHostView = ChangeHostView()
    
    var selectedPersonName: String?
    
    var delegate: ChangeHostViewControllerDelegate!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.startObservingPartyPeopleChanges(selector: #selector(partyPeopleChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingPartyPeopleChanges()
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Change Host")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc func partyPeopleChanged() {
        self.contentView.reloadTable()
        
        guard let selectedPersonName = self.selectedPersonName else { return }
        
        if Party.current.people.person(name: selectedPersonName) == nil {
            self.selectedPersonName = nil
        }
    }

}

extension ChangeHostViewController: ChangeHostViewDelegate {
    
    // MARK: - Change Host View Delegate
    
    func changeHostView(_ changeHostView: ChangeHostView, personSelected selectedPersonName: String) {
        self.selectedPersonName = selectedPersonName
    }
    
    func changeHostView(_ changeHostView: ChangeHostView, changeButtonPressed: Bool) {
        if let selectedPersonName = self.selectedPersonName {
            self.contentView.startAnimatingChangeButton()
            
            let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.details.rawValue)"
            let value = [PartyDetailsKey.hostName.rawValue: selectedPersonName]
            
            Reference.child(path).updateChildValues(value, withCompletionBlock: {
                (error, _) in
                
                self.contentView.stopAnimatingChangeButton()
                
                if let _ = error {
                    let subject = "Woah woah!"
                    let message = "We were unable to save your changes\n\nPlease try again"
                    let action = "Okay"
                    self.showAlert(subject: subject, message: message, action: action, handler: nil)
                } else {
                    self.dismissViewController(animated: true, completion: {
                        self.delegate.changeHostViewController(self, hostChanged: true)
                    })
                }
            })
        } else {
            let subject = "Woah there!"
            let message = "Please select someone to be the new host"
            let action = "Okay"
            self.showAlert(subject: subject, message: message, action: action, handler: nil)
        }
    }
    
}
