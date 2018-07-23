//
//  MenuViewController.swift
//  Partybox
//
//  Created by Christian Villa on 10/28/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import CoreMotion
import Firebase
import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Properties

    private var store: Store!

    private var authenticationHandle: AuthStateDidChangeListenerHandle!
    
    private var motionManager: CMMotionManager!
    
    private var confettiTimer: Timer!

    private var contentView: MenuView!

    // MARK: - Initialization Functions

    init() {
        super.init(nibName: nil, bundle: nil)
        self.store = Store()
        self.authenticationHandle = nil
        self.motionManager = CMMotionManager()
        self.confettiTimer = nil
        self.contentView = MenuView(delegate: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Controller Functions
    
    override func loadView() {
        self.view = self.contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
        self.startObservingAuthenticationChanges()
        self.startObservingMotionChanges()
        self.startDroppingConfetti()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().signInAnonymously(completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopObservingAuthenticationChanges()
        self.stopObservingMotionChanges()
        self.stopDroppingConfetti()
    }
    
    // MARK: - Setup Functions
    
    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .default
        self.edgesForExtendedLayout = []
        self.hideNavigationBar()
    }
    
    // MARK: - Authentication Functions
    
    private func startObservingAuthenticationChanges() {
        self.authenticationHandle = Auth.auth().addStateDidChangeListener({
            (auth, user) in
            
            if user == nil {
                self.contentView.startAnimatingStartPartyButton()
                self.contentView.startAnimatingJoinPartyButton()
                self.contentView.startAnimatingMoreButton()
            } else {
                self.contentView.stopAnimatingStartPartyButton()
                self.contentView.stopAnimatingJoinPartyButton()
                self.contentView.stopAnimatingMoreButton()
            }
        })
    }
    
    private func stopObservingAuthenticationChanges() {
        Auth.auth().removeStateDidChangeListener(self.authenticationHandle)
    }
    
    // MARK: - Motion Functions
    
    private func startObservingMotionChanges() {
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
            (motion, error) in

            guard let motion = motion else {
                return
            }

            let direction = CGVector(dx: motion.gravity.x, dy: 0.2)
            self.contentView.setConfettiGravityDirection(direction)
        })
    }
    
    private func stopObservingMotionChanges() {
        self.motionManager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Confetti Functions
    
    private func startDroppingConfetti() {
        self.confettiTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                                  target: self.contentView,
                                                  selector: #selector(MenuView.dropConfetti),
                                                  userInfo: nil,
                                                  repeats: true)
    }
    
    private func stopDroppingConfetti() {
        self.confettiTimer.invalidate()
    }

}

extension MenuViewController: MenuViewDelegate {
        
    internal func menuView(_ view: MenuView, startPartyButtonPressed: Bool) {
        let rootViewController = StartPartyViewController(store: self.store)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    internal func menuView(_ view: MenuView, joinPartyButtonPressed: Bool) {
        let rootViewController = JoinPartyViewController(store: self.store)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    internal func menuView(_ view: MenuView, moreButtonPressed: Bool) {

    }
    
}
