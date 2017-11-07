//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: PartyView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = PartyView()
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(Session.current.party.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarRightButton(title: "decorate", target: self, action: #selector(decorateButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        Session.leave()
        self.dismissViewController()
    }
    
    @objc func decorateButtonPressed() {
        
    }
    
}
