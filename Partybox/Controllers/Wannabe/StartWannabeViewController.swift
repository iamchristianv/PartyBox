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
    
    var contentView: StartWannabeView = StartWannabeView()
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupStatusBar()
        self.setupNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Setup Functions
    
    func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("How to Play")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    func startObservingChanges() {
        var name = Notification.Name(PartyNotification.peopleChanged.rawValue)
        var selector = #selector(partyPeopleChanged)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        
        name = Notification.Name(GameNotification.detailsChanged.rawValue)
        selector = #selector(gameDetailsChanged)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func stopObservingChanges() {
        var name = Notification.Name(PartyNotification.peopleChanged.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        name = Notification.Name(GameNotification.detailsChanged.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc func partyPeopleChanged() {
        self.contentView.tableView.reloadData()
        
        if User.name == Party.details.hostName {
            for i in 0 ..< Party.people.count {
                guard let person = Party.people.person(index: i) else { return }
                
                if !person.isReady {
                    return
                }
            }
            
            let randomIndex = Int(arc4random()) % Party.people.count
            
            for i in 0 ..< Party.people.count {
                guard let person = Party.people.person(index: i) else { return }
                
                Game.wannabe.people.add(WannabePerson(name: person.name, JSON: JSON("")))
                
                if i == randomIndex {
                    Game.wannabe.details.wannabeName = person.name
                }
            }
            
            Game.wannabe.details.isReady = true
            
            let path = "\(DatabaseKey.games.rawValue)"
            
            database.child(path).updateChildValues(Game.json)
        }
    }
    
    @objc func gameDetailsChanged() {
        if Game.wannabe.details.isReady {
            self.navigationController?.pushViewController(PlayWannabeViewController(), animated: true)
        }
    }

}

extension StartWannabeViewController: StartWannabeViewDelegate {
    
    // MARK: - Start Wannabe View Delegate Functions
    
    func startWannabeView(_ startWannabeView: StartWannabeView, readyToPlayButtonPressed button: UIButton) {
        guard let person = Party.people.person(name: User.name) else { return }
        
        person.isReady = true
        
        let path = "\(DatabaseKey.parties.rawValue)/\(Party.details.id)/\(PartyKey.people.rawValue)"
            
        database.child(path).updateChildValues(person.json)
    }
    
}
