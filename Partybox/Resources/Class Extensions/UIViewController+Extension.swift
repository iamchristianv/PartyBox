//
//  UIViewController+Extension.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Notification Methods
    
    func startObservingSessionNotification(_ notification: PartyNotification, selector: Selector) {
        let name = Notification.Name(notification.rawValue)
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        
        if notification == .partyDetailsChanged {
            Party.startObservingPartyDetailsChanged()
        }
        else if notification == .partyPeopleChanged {
            Party.startObservingPartyPeopleChanged()
        }
        else if notification == .gameDetailsChanged {
            Party.startObservingGameDetailsChanged()
        }
        else if notification == .gamePeopleChanged {
            Party.startObservingGamePeopleChanged()
        }
    }
    
    func stopObservingSessionNotification(_ notification: PartyNotification) {
        let name = Notification.Name(notification.rawValue)
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
        
        if notification == .partyDetailsChanged {
            Party.stopObservingPartyDetailsChanged()
        }
        else if notification == .partyPeopleChanged {
            Party.stopObservingPartyPeopleChanged()
        }
        else if notification == .gameDetailsChanged {
            Party.stopObservingGameDetailsChanged()
        }
        else if notification == .gamePeopleChanged {
            Party.stopObservingGamePeopleChanged()
        }
    }
    
    // MARK: - Navigation Bar Methods
        
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
        let alertViewController = AlertViewController(subject: subject, message: message, action: action, handler: handler)
        
        alertViewController.modalPresentationStyle = .overCurrentContext
        
        self.present(alertViewController, animated: false, completion: nil)
    }
    
    func dismissViewController(animated: Bool, completion: (() -> ())?) {
        self.dismiss(animated: animated, completion: completion)
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }

}
