//
//  BaseViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    // MARK: - Navigation Methods
        
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setNavigationBarTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    func setNavigationBarLeftButton(title: String, target: Any, action: Selector) {
        let leftButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    func setNavigationBarRightButton(title: String, target: Any, action: Selector) {
        let rightButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showStartPartyViewController() {
        let startyPartyViewController = StartPartyViewController()
        self.show(startyPartyViewController, sender: nil)
    }
    
    func showJoinPartyViewController() {
        let joinPartyViewController = JoinPartyViewController()
        self.show(joinPartyViewController, sender: nil)
    }
    
    func presentPartyViewController() {
        let partyViewController = PartyViewController()
        let navigationController = UINavigationController(rootViewController: partyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

}
