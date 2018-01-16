//
//  VoteWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 12/16/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class VoteWannabeViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: VoteWannabeView!
        
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
        self.contentView = VoteWannabeView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Vote")
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
    func showEndWannabeViewController() {
        self.navigationController?.pushViewController(EndWannabeViewController(), animated: true)
    }
    
    // MARK: - Notification Methods
    
    @objc func partyDetailsChangedNotificationObserved() {
        
    }
    
    @objc func partyPeopleChangedNotificationObserved() {
        
    }
    
    @objc func gameDetailsChangedNotificationObserved() {
        
    }
    
    @objc func gamePeopleChangedNotificationObserved() {
        var everyoneVotedForWannabe = true
        
        for i in 0 ..< Party.game.people.count {
            let person = Party.game.people.person(index: i)
            
            if person.vote.isEmpty {
                return
            }
        }
        
        for i in 0 ..< Party.game.people.count {
            let person = Party.game.people.person(index: i)
            
            if person.name != Party.game.details.wannabe && person.vote == Party.game.details.wannabe {
                person.points += 25
            }

            if person.name != Party.game.details.wannabe && person.vote != Party.game.details.wannabe {
                everyoneVotedForWannabe = false
            }
        }
        
        if everyoneVotedForWannabe {
            if Party.userHost {
                for i in 0 ..< Party.game.people.count {
                    let wannabePerson = Party.game.people.person(index: i)
                    let partyPerson = Party.people.person(name: wannabePerson.name)
                    partyPerson.ready = false
                    partyPerson.points += wannabePerson.points
                }
                
                Party.game.details.setup = false
                Party.game.details.ready = false
                Party.game.details.wannabe = ""
                Party.synchronize()
            }
            
            self.showEndWannabeViewController()
        }
        else if Party.game.details.rounds == 0 {
            if Party.userHost {
                for i in 0 ..< Party.game.people.count {
                    let wannabePerson = Party.game.people.person(index: i)
                    let partyPerson = Party.people.person(name: wannabePerson.name)
                    partyPerson.ready = false
                    partyPerson.points += wannabePerson.points
                }
                
                let partyPerson = Party.people.person(name: Party.game.details.wannabe)
                partyPerson.points += 50
                
                Party.game.details.setup = false
                Party.game.details.ready = false
                Party.synchronize()
            }
            
            self.showEndWannabeViewController()
        }
        else {
            if Party.userHost {
                for i in 0 ..< Party.game.people.count {
                    let person = Party.game.people.person(index: i)
                    person.vote = ""
                }
                
                Party.game.details.rounds -= 1
                Party.synchronize()
            }
            
            self.popViewController(animated: true)
        }
    }

}

extension VoteWannabeViewController: VoteWannabeViewDelegate {
    
    func voteWannabeView(_ voteWannabeView: VoteWannabeView, voteButtonPressed button: UIButton, forName name: String) {
        let person = Party.game.people.person(name: Party.userName)
        person.vote = name
        Party.synchronize()
    }
    
}
