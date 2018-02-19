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
    
    var contentView: VoteWannabeView = VoteWannabeView()
        
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
//        var everyoneVotedForWannabe = true
//
//        for i in 0 ..< Party.game.people.count {
//            let person = Party.game.people.person(index: i)
//
//            if person.vote.isEmpty {
//                return
//            }
//        }
//
//        for i in 0 ..< Party.game.people.count {
//            let person = Party.game.people.person(index: i)
//
//            if person.name != Party.game.details.wannabe && person.vote == Party.game.details.wannabe {
//                person.points += 25
//            }
//
//            if person.name != Party.game.details.wannabe && person.vote != Party.game.details.wannabe {
//                everyoneVotedForWannabe = false
//            }
//        }
//
//        if everyoneVotedForWannabe {
//            if Party.userHost {
//                for i in 0 ..< Party.game.people.count {
//                    let wannabePerson = Party.game.people.person(index: i)
//                    let partyPerson = Party.people.person(name: wannabePerson.name)
//                    partyPerson.ready = false
//                    partyPerson.points += wannabePerson.points
//                }
//
//                Party.game.details.setup = false
//                Party.game.details.ready = false
//                Party.game.details.wannabe = ""
//                Party.synchronize()
//            }
//
//            self.navigationController?.pushViewController(EndWannabeViewController(), animated: true)
//        }
//        else if Party.game.details.rounds == 0 {
//            if Party.userHost {
//                for i in 0 ..< Party.game.people.count {
//                    let wannabePerson = Party.game.people.person(index: i)
//                    let partyPerson = Party.people.person(name: wannabePerson.name)
//                    partyPerson.ready = false
//                    partyPerson.points += wannabePerson.points
//                }
//
//                let partyPerson = Party.people.person(name: Party.game.details.wannabe)
//                partyPerson.points += 50
//
//                Party.game.details.setup = false
//                Party.game.details.ready = false
//                Party.synchronize()
//            }
//
//            self.navigationController?.pushViewController(EndWannabeViewController(), animated: true)
//        }
//        else {
//            if Party.userHost {
//                for i in 0 ..< Party.game.people.count {
//                    let person = Party.game.people.person(index: i)
//                    person.vote = ""
//                }
//
//                Party.game.details.rounds -= 1
//                Party.synchronize()
//            }
//
//            self.popViewController(animated: true)
//        }
    }

}

extension VoteWannabeViewController: VoteWannabeViewDelegate {
    
    // MARK: - Vote Wannabe View Delegate Functions
    
    func voteWannabeView(_ voteWannabeView: VoteWannabeView, voteButtonPressed button: UIButton, forName name: String) {
//        let person = Party.game.people.person(name: Party.userName)
//        person.vote = name
//        Party.synchronize()
    }
    
}
