//
//  ManagePartyViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ManagePartyViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: ManagePartyView = ManagePartyView()
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        //self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    // MARK: - Setup Functions
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Manage Party")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }

}
