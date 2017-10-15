//
//  PartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/15/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class PartyViewController: BaseViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    
    var party: Party!
    
    var person: Person!
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    // MARK: - Configuration
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle(party.name)
        self.setNavigationBarLeftButton(title: "leave", target: self, action: #selector(leaveButtonPressed))
    }
    
    // MARK: - Navigation
    
    @objc func leaveButtonPressed() {
        self.dismissController()
    }

}
