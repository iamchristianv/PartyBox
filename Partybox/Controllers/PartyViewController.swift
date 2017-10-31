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
    
    var party: Party
    
    // MARK: - Initialization Methods
    
    init(party: Party) {
        self.party = party
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = PartyView()
        self.contentView.configure(party: self.party)
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(self.party.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
        self.setNavigationBarRightButton(title: "decorate", target: self, action: #selector(decorateButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func leaveButtonPressed() {
        self.dimiss()
    }
    
    @objc func decorateButtonPressed() {
        
    }
    
}
