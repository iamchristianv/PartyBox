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
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = StartWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: PartyNotification.peopleChanged.rawValue, selector: #selector(partyPeopleChanged))
        self.startObservingNotification(name: GameNotification.detailsChanged.rawValue, selector: #selector(gameDetailsChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: PartyNotification.peopleChanged.rawValue)
        self.stopObservingNotification(name: GameNotification.detailsChanged.rawValue)
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("How to Play")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Navigation Bar Functions
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc func partyPeopleChanged() {
        self.contentView.reloadTable()
        
        if User.current.name == Party.current.details.hostName {
            return
        }
        
        for i in 0 ..< Party.current.people.count {
            guard let person = Party.current.people.person(index: i) else { return }
            
            if !person.isReady {
                return
            }
        }
        
        let randomIndex = Int(arc4random()) % Party.current.people.count
        
        for i in 0 ..< Party.current.people.count {
            guard let person = Party.current.people.person(index: i) else { return }
            
            Wannabe.current.people.add(WannabePerson(name: person.name))
            
            if i == randomIndex {
                Wannabe.current.details.wannabeName = person.name
            }
        }
        
        Wannabe.current.details.isReady = true
        
        let path = "\(ReferenceKey.games.rawValue)"
        let value = Wannabe.current.json
        
        Reference.current.database.child(path).updateChildValues(value)
    }
    
    @objc func gameDetailsChanged() {
        if Wannabe.current.details.isReady {
            self.pushPlayWannabeViewController()
        }
    }

}

extension StartWannabeViewController: StartWannabeViewDelegate {
    
    // MARK: - Start Wannabe View Delegate Functions
    
    func startWannabeView(_ startWannabeView: StartWannabeView, readyButtonPressed: Bool) {
        guard let person = Party.current.people.person(name: User.current.name) else { return }
        
        person.isReady = true
        
        let path = "\(ReferenceKey.parties.rawValue)/\(Party.current.details.id)/\(PartyKey.people.rawValue)"
        let value = [person.name: person.json]
            
        Reference.current.database.child(path).updateChildValues(value)
    }
    
}
