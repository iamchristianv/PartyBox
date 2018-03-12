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
    
    var contentView: ChangeHostView!
    
    var delegate: ChangeHostViewControllerDelegate!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = ChangeHostView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: PartyNotification.peopleChanged.rawValue, selector: #selector(partyPeopleChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.peopleChanged.rawValue)
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
    }
    
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
        
        if Party.current.people.person(name: self.contentView.selectedPersonName) == nil {
            self.contentView.selectedPersonName = Party.current.details.hostName
            self.contentView.reloadTable()
        }
    }

}

extension ChangeHostViewController: ChangeHostViewDelegate {
    
    // MARK: - Change Host View Delegate
    
    func changeHostView(_ changeHostView: ChangeHostView, changeButtonPressed: Bool) {
        if self.contentView.selectedPersonNameValue() == Party.current.details.hostName {
            self.showUserNeedsToSelectNewHostAlert(handler: nil)
        } else {
            self.contentView.startAnimatingChangeButton()
            
            Party.current.setHostName(name: self.contentView.selectedPersonNameValue(), callback: {
                (error) in
                
                self.contentView.stopAnimatingChangeButton()
                
                if let error = error {
                    self.showErrorAlert(error: error)
                } else {
                    self.dismissViewController(animated: true, completion: {
                        self.delegate.changeHostViewController(self, hostChanged: true)
                    })
                }
            })
        }
    }
    
}
