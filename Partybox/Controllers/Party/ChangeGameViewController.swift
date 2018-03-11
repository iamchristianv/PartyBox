//
//  ChangeGameViewController.swift
//  Partybox
//
//  Created by Christian Villa on 2/17/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class ChangeGameViewController: UIViewController {

    // MARK: - Instance Properties
    
    var contentView: ChangeGameView!
    
    // MARK: - View Controller Functions
    
    override func loadView() {
        self.contentView = ChangeGameView()
        self.contentView.delegate = self
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
    }
    
    // MARK: - Setup Functions
    
    func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.showNavigationBar()
        self.setNavigationBarTitle("Change Game")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(UIColor.Partybox.green)
    }
    
    // MARK: - Action Functions
    
    @objc func cancelButtonPressed() {
        self.dismissViewController(animated: true, completion: nil)
    }
    
}

extension ChangeGameViewController: ChangeGameViewDelegate {
    
    // MARK: - Change Game View Delegate Functions
    
    func changeGameView(_ changeGameView: ChangeGameView, changeButtonPressed: Bool) {
        
    }
    
}
