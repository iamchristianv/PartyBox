//
//  StartSpyfallViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit
import SwiftyJSON

class StartSpyfallViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: StartSpyfallView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
        self.startObservingSessionNotification(.partyChanged, selector: #selector(partyChangedNotificationObserved))
        self.startObservingSessionNotification(.gameChanged, selector: #selector(gameChangedNotificationObserved))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopObservingSessionNotification(.partyChanged)
        self.stopObservingSessionNotification(.gameChanged)
    }
    
    override func loadView() {
        self.contentView = StartSpyfallView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("How to Play")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Methods
    
    @objc func partyChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        
        for i in 0 ..< Session.party.people.count {
            if let partyPerson = Session.party.people.person(index: i), !partyPerson.ready {
                return
            }
        }
        
        if Session.host {
            let randomIndex = Int(arc4random()) % Session.party.people.count
            
            for i in 0 ..< Session.party.people.count {
                if let partyPerson = Session.party.people.person(index: i) {
                    Session.game.people.add(SpyfallPerson(name: partyPerson.name, spy: i == randomIndex))
                }
            }
            
            Session.game.details.ready = true
            
            Session.database.child("sessions").updateChildValues(Session.toJSON())
        }
    }
    
    @objc func gameChangedNotificationObserved() {
        if Session.game.details.ready {
            self.showPlaySpyfallViewController()
        }
    }

}

extension StartSpyfallViewController: StartSpyfallViewDelegate {
    
    // MARK: - Start Spyfall View Delegate Methods
    
    func startSpyfallView(_ startSpyfallView: StartSpyfallView, readyToPlayButtonPressed button: UIButton) {
        guard let partyPerson = Session.party.people.person(name: Session.name) else {
            return
        }
        
        partyPerson.ready = true
        
        Session.database.child("sessions").updateChildValues(Session.toJSON())
    }
    
}
