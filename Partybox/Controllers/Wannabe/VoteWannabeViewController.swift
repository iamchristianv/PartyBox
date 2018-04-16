//
//  VoteWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import UIKit

class VoteWannabeViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: VoteWannabeView!
        
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = VoteWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.setupNavigationBar()
        self.startObservingNotification(name: GameNotification.peopleChanged.rawValue, selector: #selector(gamePeopleChanged))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingNotification(name: GameNotification.peopleChanged.rawValue)
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Vote")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    @objc func gamePeopleChanged() {
        var everyoneVotedForWannabe = true

        for i in 0 ..< Wannabe.current.people.count {
            guard let person = Wannabe.current.people.person(index: i) else { return }

            if person.voteName.isEmpty {
                return
            }
        }

        for i in 0 ..< Wannabe.current.people.count {
            guard let person = Wannabe.current.people.person(index: i) else { return }

            if person.name != Wannabe.current.details.wannabeName && person.voteName == Wannabe.current.details.wannabeName {
                person.points += 25
            }

            if person.name != Wannabe.current.details.wannabeName && person.voteName != Wannabe.current.details.wannabeName {
                everyoneVotedForWannabe = false
            }
        }

        if everyoneVotedForWannabe {
            if User.current.name == Party.current.details.hostName {
                for i in 0 ..< Wannabe.current.people.count {
                    guard let wannabePerson = Wannabe.current.people.person(index: i) else { return }
                    guard let partyPerson = Party.current.people.person(name: wannabePerson.name) else { return }
                    partyPerson.isReady = false
                    partyPerson.points += wannabePerson.points
                }

                Wannabe.current.details.isSetup = false
                Wannabe.current.details.isReady = false
                Wannabe.current.details.wannabeName = ""
                
                let path = "\(DatabaseKey.games.rawValue)"
                let value = Wannabe.current.json
                
                Database.current.child(path).updateChildValues(value)
            }

            self.pushEndWannabeViewController()
        } else if Wannabe.current.details.rounds == 0 {
            if User.current.name == Party.current.details.hostName {
                for i in 0 ..< Wannabe.current.people.count {
                    guard let wannabePerson = Party.current.people.person(index: i) else { return }
                    guard let partyPerson = Party.current.people.person(name: wannabePerson.name) else { return }
                    partyPerson.isReady = false
                    partyPerson.points += wannabePerson.points
                }

                guard let partyPerson = Party.current.people.person(name: Wannabe.current.details.wannabeName) else { return }
                partyPerson.points += 50

                Wannabe.current.details.isSetup = false
                Wannabe.current.details.isReady = false
                Wannabe.current.details.wannabeName = ""
                
                let path = "\(DatabaseKey.games.rawValue)"
                let value = Wannabe.current.json
                
                Database.current.child(path).updateChildValues(value)
            }

            self.pushEndWannabeViewController()
        } else {
            if User.current.name == Party.current.details.hostName {
                for i in 0 ..< Wannabe.current.people.count {
                    guard let person = Wannabe.current.people.person(index: i) else { return }
                    person.voteName = ""
                }

                Wannabe.current.details.rounds -= 1
                
                let path = "\(DatabaseKey.games.rawValue)"
                let value = Wannabe.current.json
                
                Database.current.child(path).updateChildValues(value)            }

            self.popViewController(animated: true)
        }
    }

}

extension VoteWannabeViewController: VoteWannabeViewDelegate {
    
    // MARK: - Vote Wannabe View Delegate Functions
    
    func voteWannabeView(_ voteWannabeView: VoteWannabeView, voteButtonPressed: Bool) {
        guard let person = Wannabe.current.people.person(name: User.current.name) else { return }
        
        person.voteName = self.contentView.selectedPersonNameValue()
        
        let path = "\(DatabaseKey.games.rawValue)/\(Party.current.details.id)/\(GameKey.people.rawValue)"
        let value = [person.name: person.json]
        
        Database.current.child(path).updateChildValues(value)
    }
    
}
