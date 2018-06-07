//
//  SetupWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 5/29/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SetupWannabeViewController: UIViewController {

    // MARK: - Instance Properties

    private var session: Session!

    private var contentView: SetupWannabeView!

    // MARK: - Construction Functions

    static func construct(session: Session) -> SetupWannabeViewController {
        let controller = SetupWannabeViewController()
        controller.session = session
        controller.contentView = SetupWannabeView.construct(delegate: controller)
        return controller
    }

    // MARK: - View Controller Functions

    override func loadView() {
        self.view = self.contentView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewController()
    }

    // MARK: - Setup Functions

    private func setupViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.edgesForExtendedLayout = []
        self.showNavigationBar()
        self.setNavigationBarTitle("Setup Wannabe")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }

    // MARK: - Action Functions

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SetupWannabeViewController: SetupWannabeViewDelegate {

    internal func setupWannabeView(_ view: SetupWannabeView, roundsNameTextFieldPressed: Bool) {
        let rootViewController = SelectWannabeRoundsViewController.construct(session: self.session, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    internal func setupWannabeView(_ view: SetupWannabeView, packNameTextFieldPressed: Bool) {
        let rootViewController = SelectWannabePackViewController.construct(session: self.session, delegate: self)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.present(navigationController, animated: true, completion: nil)
    }

    internal func setupWannabeView(_ view: SetupWannabeView, playButtonPressed: Bool) {
        
    }

}

extension SetupWannabeViewController: SelectWannabeRoundsViewControllerDelegate {

    func selectWannabeRoundsViewController(_ controller: SelectWannabeRoundsViewController, roundsSelected rounds: Int) {
        self.contentView.roundsName = "\(rounds) Rounds"
    }

}

extension SetupWannabeViewController: SelectWannabePackViewControllerDelegate {

    func selectWannabePackViewController(_ controller: SelectWannabePackViewController, packSelected pack: WannabePack) {
        self.contentView.packName = pack.details.name
    }

}
