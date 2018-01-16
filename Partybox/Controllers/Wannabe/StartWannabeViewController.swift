//
//  StartWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/11/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import SwiftyJSON
import UIKit

class StartWannabeViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: StartWannabeView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
        self.configureNavigationBar()
        self.startObservingSessionNotification(.partyDetailsChanged, selector: #selector(partyDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.partyPeopleChanged, selector: #selector(partyPeopleChangedNotificationObserved))
        self.startObservingSessionNotification(.gameDetailsChanged, selector: #selector(gameDetailsChangedNotificationObserved))
        self.startObservingSessionNotification(.gamePeopleChanged, selector: #selector(gamePeopleChangedNotificationObserved))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopObservingSessionNotification(.partyDetailsChanged)
        self.stopObservingSessionNotification(.partyPeopleChanged)
        self.stopObservingSessionNotification(.gameDetailsChanged)
        self.stopObservingSessionNotification(.gamePeopleChanged)
    }
    
    override func loadView() {
        self.contentView = StartWannabeView()
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
    
    func showPlayWannabeViewController() {
        self.navigationController?.pushViewController(PlayWannabeViewController(), animated: true)
    }
    
    // MARK: - Notification Methods
    
    @objc func partyDetailsChangedNotificationObserved() {
        
    }
    
    @objc func partyPeopleChangedNotificationObserved() {
        self.contentView.tableView.reloadData()
        
        if Party.userHost {
            for i in 0 ..< Party.people.count {
                let person = Party.people.person(index: i)
                
                if !person.ready {
                    return
                }
            }
            
            let randomIndex = Int(arc4random()) % Party.people.count
            
            for i in 0 ..< Party.people.count {
                let person = Party.people.person(index: i)
                
                Party.game.people.add(WannabePerson(name: person.name))
                
                if i == randomIndex {
                    Party.game.details.wannabe = person.name
                }
            }
            
            Party.game.details.ready = true
            Party.synchronize()
        }
    }
    
    @objc func gameDetailsChangedNotificationObserved() {
        if Party.game.details.ready {
            self.showPlayWannabeViewController()
        }
    }
    
    @objc func gamePeopleChangedNotificationObserved() {
        
    }

}

extension StartWannabeViewController: StartWannabeViewDelegate {
    
    // MARK: - Start Wannabe View Delegate Methods
    
    func startWannabeView(_ startWannabeView: StartWannabeView, readyToPlayButtonPressed button: UIButton) {
        let person = Party.people.person(name: Party.userName)
        person.ready = true
        Party.database.child("\(Party.inviteCode)/\(PartyKey.people.rawValue)").updateChildValues(person.toJSON())
    }
    
}
