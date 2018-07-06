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
        let titleTextAttributes = [NSAttributedStringKey.font: Partybox.font.avenirNextRegular(size: 18),
                                   NSAttributedStringKey.foregroundColor: Partybox.color.white] as [NSAttributedStringKey : Any]
        leftButton.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    func setNavigationBarRightButton(title: String?, target: Any?, action: Selector?) {
        let rightButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        let titleTextAttributes = [NSAttributedStringKey.font: Partybox.font.avenirNextRegular(size: 18),
                                   NSAttributedStringKey.foregroundColor: Partybox.color.white] as [NSAttributedStringKey : Any]
        rightButton.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    func setNavigationBarBackgroundColor(_ color: UIColor) {
        self.navigationController?.navigationBar.barTintColor = color
        let titleTextAttributes = [NSAttributedStringKey.font: Partybox.font.avenirNextMedium(size: 19),
                                   NSAttributedStringKey.foregroundColor: Partybox.color.white] as [NSAttributedStringKey : Any]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
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

    // MARK: - Alert Functions

    func showAlert(subject: String, message: String, action: String, handler: (() -> ())?) {
        let alertViewController = AlertViewController()
        alertViewController.alert = Alert(subject: subject, message: message, action: action, handler: handler)
        alertViewController.modalPresentationStyle = .overCurrentContext
        self.present(alertViewController, animated: false, completion: nil)
    }

}
