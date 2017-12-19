//
//  SetupSpyfallViewController.swift
//  Partybox
//
//  Created by Christian Villa on 11/25/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit
import SwiftyJSON

class SetupSpyfallViewController: BaseViewController {

    // MARK: - Instance Properties
    
    var contentView: SetupSpyfallView!
    
    // MARK: - View Controller Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBar()
    }
    
    override func loadView() {
        self.contentView = SetupSpyfallView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    // MARK: - Configuration Methods
    
    func configureNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Setup Spyfall")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
    }
    
    // MARK: - Navigation Methods
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}

extension SetupSpyfallViewController: SetupSpyfallViewDelegate {
    
    // MARK: - Setup Spyfall View Delegate
    
    func setupSpyfallView(_ setupSpyfallView: SetupSpyfallView, playGameButtonPressed button: UIButton) {
        Session.database.child("packs/\(Session.game.details.code)/default").observe(.value, with: {
            (snapshot) in
            
            guard let snapshotJSON = snapshot.value as? [String: Any] else{
                return
            }
            
            let packJSON = JSON(snapshotJSON)
            
            Session.game.details.duration = 2
            Session.game.details.setup = true
            
            Session.game.pack = SpyfallPack(JSON: packJSON)
            Session.game.pack.selectRandomCard()
            
            Session.database.child("sessions").updateChildValues(Session.toJSON())
            
            self.dismissViewController(animated: true, completion: nil)
        })
    }
    
}
