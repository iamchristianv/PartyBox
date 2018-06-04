//
//  SelectWannabePackViewController.swift
//  Partybox
//
//  Created by Christian Villa on 5/31/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import UIKit

class SelectWannabePackViewController: UIViewController {

    // MARK: - Instance Properties

    private var session: Session!

    private var contentView: SelectWannabePackView!

    private var delegate: SelectWannabePackViewControllerDelegate!

    // MARK: - Construction Functions

    static func construct(session: Session, delegate: SelectWannabePackViewControllerDelegate) -> SelectWannabePackViewController {
        let controller = SelectWannabePackViewController()
        controller.session = session
        controller.contentView = SelectWannabePackView.construct(delegate: controller, dataSource: controller)
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
        self.setNavigationBarTitle("Select Pack")
        self.setNavigationBarLeftButton(title: "cancel", target: self, action: #selector(cancelButtonPressed))
        self.setNavigationBarBackgroundColor(Partybox.colors.green)
    }

    // MARK: - Navigation Bar Functions

    @objc private func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SelectWannabePackViewController: SelectWannabePackViewDelegate {

    func selectWannabePackView(_ selectWannabePackView: SelectWannabePackView, saveButtonPressed: Bool) {

    }

}

extension SelectWannabePackViewController: SelectWannabePackViewDataSource {

    func selectWannabePackViewPacksCount() -> Int {
        return 0
    }

    func selectWannabePackViewPack(index: Int) -> WannabePack? {
        return nil
    }

}
