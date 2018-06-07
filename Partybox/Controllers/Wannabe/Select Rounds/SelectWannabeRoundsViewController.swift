//
//  SelectWannabeRoundsViewController.swift
//  Partybox
//
//  Created by Christian Villa on 5/30/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SelectWannabeRoundsViewController: UIViewController {

    // MARK: - Instance Properties

    private var session: Session!

    private var contentView: SelectWannabeRoundsView!

    private var delegate: SelectWannabeRoundsViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(session: Session, delegate: SelectWannabeRoundsViewControllerDelegate) -> SelectWannabeRoundsViewController {
        let controller = SelectWannabeRoundsViewController()
        controller.session = session
        controller.contentView = SelectWannabeRoundsView.construct(delegate: controller, dataSource: controller)
        controller.delegate = delegate
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
        self.setNavigationBarTitle("Select Rounds")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }

    // MARK: - Navigation Bar Functions

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SelectWannabeRoundsViewController: SelectWannabeRoundsViewDelegate {

    internal func selectWannabeRoundsView(_ selectWannabeRoundsView: SelectWannabeRoundsView, saveButtonPressed: Bool) {
        self.delegate.selectWannabeRoundsViewController(self, roundsSelected: self.contentView.rounds)
        self.dismiss(animated: true, completion: nil)
    }

}

extension SelectWannabeRoundsViewController: SelectWannabeRoundsViewDataSource {

    internal func selectWannabeRoundsViewRoundsCount() -> Int {
        return self.session.wannabe.manual.rounds.count
    }

    internal func selectWannabeRoundsViewRounds(index: Int) -> Int {
        return self.session.wannabe.manual.rounds[index]
    }

}
