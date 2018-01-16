//
//  MenuView.swift
//  Partybox
//
//  Created by Christian Villa on 10/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    // MARK: - Instance Properties
    
    lazy var startPartyButton: ActivityButton = {
        let startPartyButton = ActivityButton()
        startPartyButton.setTitle("Start Party", for: .normal)
        startPartyButton.setTitleFont(UIFont.avenirNextMediumName, size: 24)
        startPartyButton.setBackgroundColor(UIColor.Partybox.red)
        return startPartyButton
    }()
    
    lazy var joinPartyButton: ActivityButton = {
        let joinPartyButton = ActivityButton()
        joinPartyButton.setTitle("Join Party", for: .normal)
        joinPartyButton.setTitleFont(UIFont.avenirNextMediumName, size: 24)
        joinPartyButton.setBackgroundColor(UIColor.Partybox.blue)
        return joinPartyButton
    }()
    
    lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        animator.addBehavior(self.gravityBehavior)
        animator.addBehavior(self.confettiBehavior)
        return animator
    }()
    
    lazy var gravityBehavior: UIGravityBehavior = {
        let gravityBehavior = UIGravityBehavior()
        gravityBehavior.magnitude = 0.025
        return gravityBehavior
    }()
    
    lazy var confettiBehavior: UIDynamicItemBehavior = {
        let confettiBehavior = UIDynamicItemBehavior()
        confettiBehavior.allowsRotation = true
        return confettiBehavior
    }()
    
    // MARK: - Initialization Methods
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configureSubviews() {
        self.addSubview(self.startPartyButton)
        self.addSubview(self.joinPartyButton)
        
        self.startPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(250)
            make.height.equalTo(62.5)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        self.joinPartyButton.snp.remakeConstraints({
            (make) in
            
            make.width.equalTo(250)
            make.height.equalTo(62.5)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.startPartyButton.snp.bottom).offset(48)
        })
    }
    
    // MARK: - Animation Methods
    
    func startAnimatingStartPartyButton() {
        self.startPartyButton.startAnimating()
    }
    
    func stopAnimatingStartPartyButton() {
        self.startPartyButton.stopAnimating()
    }
    
    func startAnimatingJoinPartyButton() {
        self.joinPartyButton.startAnimating()
    }
    
    func stopAnimatingJoinPartyButton() {
        self.joinPartyButton.stopAnimating()
    }
    
    // MARK: - Confetti Methods
    
    func dropConfettiPiece() {
        
        // TODO: - refactor and optimize
        
        let randomX = Int(arc4random()) % Int(self.frame.size.width)
        let randomFrame = CGRect(x: randomX, y: -15, width: 15, height: 15)
        
        let colors = [UIColor.Partybox.red, UIColor.Partybox.blue, UIColor.Partybox.purple, UIColor.Partybox.green]
        let randomColor = colors[Int(arc4random()) % colors.count]
        
        let shapes = [SquareView.self, TriangleView.self, CircleView.self]
        let randomShape = shapes[Int(arc4random()) % shapes.count]
        
        var confettiPiece: ShapeView!
        
        if randomShape == SquareView.self {
            confettiPiece = SquareView(frame: randomFrame, color: randomColor)
        }
        else if randomShape == TriangleView.self {
            confettiPiece = TriangleView(frame: randomFrame, color: randomColor)
        }
        else if randomShape == CircleView.self {
            confettiPiece = CircleView(frame: randomFrame, color: randomColor)
        }
        
        self.animator.referenceView?.insertSubview(confettiPiece, at: 0)
        self.gravityBehavior.addItem(confettiPiece)
        self.confettiBehavior.addItem(confettiPiece)
        
        let randomDirection = Int(arc4random()) % 2
        let randomVelocity = randomDirection == 0 ? 5.0 : -5.0
        
        self.confettiBehavior.addAngularVelocity(CGFloat(randomVelocity), for: confettiPiece)
    }
    
}
