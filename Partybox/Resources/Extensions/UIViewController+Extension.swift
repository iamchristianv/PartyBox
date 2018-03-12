//
//  UIViewController+Extension.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Navigation Bar Functions
        
    func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setNavigationBarTitle(_ title: String) {
        self.navigationItem.title = title
    }
    
    func setNavigationBarLeftButton(title: String?, target: Any?, action: Selector?) {
        let leftButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        let titleTextAttributes = [NSAttributedStringKey.font: UIFont.avenirNextRegular(size: 18),
                                   NSAttributedStringKey.foregroundColor: UIColor.Partybox.white] as [NSAttributedStringKey : Any]
        leftButton.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    func setNavigationBarRightButton(title: String?, target: Any?, action: Selector?) {
        let rightButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        let titleTextAttributes = [NSAttributedStringKey.font: UIFont.avenirNextRegular(size: 18),
                                   NSAttributedStringKey.foregroundColor: UIColor.Partybox.white] as [NSAttributedStringKey : Any]
        rightButton.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    func setNavigationBarBackgroundColor(_ color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
        let titleTextAttributes = [NSAttributedStringKey.font: UIFont.avenirNextMedium(size: 19),
                                   NSAttributedStringKey.foregroundColor: color.contrastColor()] as [NSAttributedStringKey : Any]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    func showAlert(subject: String, message: String, action: String, handler: (() -> ())?) {
        let alertViewController = AlertViewController(alert: Alert(subject: subject, message: message, action: action, handler: handler))
        alertViewController.modalPresentationStyle = .overCurrentContext
        self.present(alertViewController, animated: false, completion: nil)
    }
    
    // MARK: - Notification Functions
    
    func startObservingNotification(name: String, selector: Selector) {
        let name = Notification.Name(name)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func stopObservingNotification(name: String) {
        let name = Notification.Name(name)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    // MARK: - View Controller Functions
    
    func showStartPartyViewController() {
        let startPartyViewController = StartPartyViewController()
        let navigationController = UINavigationController(rootViewController: startPartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showJoinPartyViewController() {
        let joinPartyViewController = JoinPartyViewController()
        let navigationController = UINavigationController(rootViewController: joinPartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showPartyViewController(delegate: PartyViewControllerDelegate) {
        let partyViewController = PartyViewController()
        partyViewController.delegate = delegate
        let navigationController = UINavigationController(rootViewController: partyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChangeHostViewController(delegate: ChangeHostViewControllerDelegate) {
        let changeHostViewController = ChangeHostViewController()
        changeHostViewController.delegate = delegate
        let navigationController = UINavigationController(rootViewController: changeHostViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showManagePartyViewController() {
        let managePartyViewController = ManagePartyViewController()
        let navigationController = UINavigationController(rootViewController: managePartyViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showChangeGameViewController() {
        let changeGameViewController = ChangeGameViewController()
        let navigationController = UINavigationController(rootViewController: changeGameViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showSetupWannabeViewController() {
        let setupWannabeViewController = SetupWannabeViewController()
        let navigationController = UINavigationController(rootViewController: setupWannabeViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func showStartWannabeViewController() {
        let startWannabeViewController = StartWannabeViewController()
        let navigationController = UINavigationController(rootViewController: startWannabeViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func pushStartWannabeViewController() {
        let startWannabeViewController = StartWannabeViewController()
        self.navigationController?.pushViewController(startWannabeViewController, animated: true)
    }
    
    func pushPlayWannabeViewController() {
        let playWannabeViewController = PlayWannabeViewController()
        self.navigationController?.pushViewController(playWannabeViewController, animated: true)
    }
        
    func dismissViewController(animated: Bool, completion: (() -> ())?) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    // MARK: - Alert Functions
    
    func showErrorAlert(error: String) {
        let subject = "Whoops!"
        let message = error
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }
    
    func showUserWasKickedFromPartyAlert() {
        let subject = "Whoops!"
        let message = "You were kicked from the party by the host"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: nil)
    }
    
    func showUserWantsToLeavePartyAlert(handler: (() -> ())?) {
        let subject = "Woah!"
        let message = "Are you sure you want to leave the party?"
        let action = "Leave"
        self.showAlert(subject: subject, message: message, action: action, handler: handler)
    }
    
    func showUserIsNewPartyHostAlert(handler: (() -> ())?) {
        let subject = "Woah!"
        let message = "You are the host of the party\n\nTell your friends to join with the invite code"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: handler)
    }
    
    func showUserWantsToKickPersonFromPartyAlert(handler: (() -> ())?) {
        let subject = "Slow down ✋"
        let message = "Are you sure you want to kick them from your party?"
        let action = "Kick"
        self.showAlert(subject: subject, message: message, action: action, handler: handler)
    }
    
    func showUserNeedsToSelectNewHostAlert(handler: (() -> ())?) {
        let subject = "Woah there!"
        let message = "Please select a new person to be the host before you leave"
        let action = "Okay"
        self.showAlert(subject: subject, message: message, action: action, handler: handler)
    }

}
