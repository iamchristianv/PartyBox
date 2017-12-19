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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
    }
    
    // MARK: - Notification Methods
    
    func startObservingSessionNotification(_ notification: SessionNotification, selector: Selector) {
        let name = Notification.Name(notification.rawValue)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        
        Session.startObservingNotification(notification)
    }
    
    func stopObservingSessionNotification(_ notification: SessionNotification) {
        let name = Notification.Name(notification.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        Session.stopObservingNotification(notification)
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
    
    func showAlert(alert: String, message: String, action: String, actionBlock: (() -> ())?) {
        let alertViewController = AlertViewController(alert: alert, message: message, action: action, actionBlock: actionBlock)
        alertViewController.modalPresentationStyle = .overCurrentContext
        self.present(alertViewController, animated: false, completion: nil)
    }
    
    func showStartPartyViewController() {
        let startyPartyViewController = StartPartyViewController()
        let navigationController = UINavigationController(rootViewController: startyPartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showJoinPartyViewController() {
        let joinPartyViewController = JoinPartyViewController()
        let navigationController = UINavigationController(rootViewController: joinPartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showPartyViewController() {
        let partyViewController = PartyViewController()
        let navigationController = UINavigationController(rootViewController: partyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showSetupSpyfallViewController() {
        let setupSpyfallViewController = SetupSpyfallViewController()
        let navigationController = UINavigationController(rootViewController: setupSpyfallViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showStartSpyfallViewController() {
        let startSpyfallViewController = StartSpyfallViewController()
        let navigationController = UINavigationController(rootViewController: startSpyfallViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showPlaySpyfallViewController() {
        let playSpyfallViewController = PlaySpyfallViewController()
        self.navigationController?.pushViewController(playSpyfallViewController, animated: true)
    }
    
    func showEndSpyfallViewController() {
        let endSpyfallViewController = EndSpyfallViewController()
        self.navigationController?.pushViewController(endSpyfallViewController, animated: true)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> ())?) {
        self.dismiss(animated: animated, completion: completion)
    }

}
