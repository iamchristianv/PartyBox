//
//  BaseViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/5/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Navigation
    
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setNavigationBarTitle(_ title: String?) {
        self.navigationItem.title = title
    }
    
    func setNavigationBarLeftButton(title: String?, target: Any?, action: Selector?) {
        let leftButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    func setNavigationBarRightButton(title: String?, target: Any?, action: Selector?) {
        let rightButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    func showMenuController() {
        let menuViewController = viewController(type: MenuViewController.self)
        self.show(menuViewController, sender: nil)
    }

    func showPrePartyController(type: PrePartyViewControllerType) {
        let prePartyViewController = viewController(type: PrePartyViewController.self) as! PrePartyViewController
        prePartyViewController.type = type
        self.show(prePartyViewController, sender: nil)
    }
    
    func showPartyController(party: Party, person: Person) {
        let partyViewController = viewController(type: PartyViewController.self) as! PartyViewController
        partyViewController.party = party
        partyViewController.person = person
        self.show(partyViewController, sender: nil)
    }
    
    func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Utility
    
    func viewController(type: UIViewController.Type) -> UIViewController {
        let className = String(describing: type)
        let storyboard = UIStoryboard(name: className, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: className)
        
        return viewController
    }
    
}
