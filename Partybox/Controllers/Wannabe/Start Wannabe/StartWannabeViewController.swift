//
//  StartWannabeViewController.swift
//  Partybox
//
//  Created by Christian Villa on 6/7/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class StartWannabeViewController: UIViewController {

    // MARK: - Instance Properties

    private var session: Session!

    private var contentView: StartWannabeView!

    // MARK: - Construction Functions

    static func construct(session: Session) -> StartWannabeViewController {
        let controller = StartWannabeViewController()
        controller.session = session
        controller.contentView = StartWannabeView.construct(delegate: controller, dataSource: controller)
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
        self.setNavigationBarTitle("Start Wannabe")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }

    // MARK: - Action Functions

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension StartWannabeViewController: StartWannabeViewDelegate {

    func startWannabeView(_ view: StartWannabeView, readyButtonPressed: Bool) {
        self.contentView.startAnimatingReadyButton()
    }

}

extension StartWannabeViewController: StartWannabeViewDataSource {

    func startWannabeViewGameName() -> String {
        return self.session.wannabe.details.name
    }

    func startWannabeViewGameInstructions() -> String {
        return self.session.wannabe.manual.instructions
    }

}
