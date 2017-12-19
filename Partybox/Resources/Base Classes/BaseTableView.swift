//
//  BaseTableView.swift
//  Partybox
//
//  Created by Christian Villa on 10/29/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {

    // MARK: - Initialization Methods
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        //self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 50
        
        self.register(PromptTableViewCell.self, forCellReuseIdentifier: PromptTableViewCell.identifier)
        self.register(HeaderTableViewCell.self, forCellReuseIdentifier: HeaderTableViewCell.identifier)
        self.register(WaitingTableViewCell.self, forCellReuseIdentifier: WaitingTableViewCell.identifier)
        self.register(SingleButtonTableViewCell.self, forCellReuseIdentifier: SingleButtonTableViewCell.identifier)
        self.register(DoubleButtonTableViewCell.self, forCellReuseIdentifier: DoubleButtonTableViewCell.identifier)
        self.register(PartyGameTableViewCell.self, forCellReuseIdentifier: PartyGameTableViewCell.identifier)
        self.register(PartyPersonTableViewCell.self, forCellReuseIdentifier: PartyPersonTableViewCell.identifier)
        self.register(GameInstructionsTableViewCell.self, forCellReuseIdentifier: GameInstructionsTableViewCell.identifier)
        self.register(GameCountdownTableViewCell.self, forCellReuseIdentifier: GameCountdownTableViewCell.identifier)
        
        self.tableFooterView = UIView(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Party View Table View Cell Methods
    
    func inviteCodeCell() -> PromptTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PromptTableViewCell.identifier)
        let promptCell = tableViewCell as! PromptTableViewCell
        promptCell.setPrompt("Invite Code: " + Session.code)
        return promptCell
    }
    
    func partyGameHeaderCell() -> HeaderTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
        let headerCell = tableViewCell as! HeaderTableViewCell
        headerCell.setHeader("PARTY GAME")
        headerCell.setEmoji("🎉")
        return headerCell
    }
    
    func partyGameCell() -> PartyGameTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PartyGameTableViewCell.identifier)
        let partyGameCell = tableViewCell as! PartyGameTableViewCell
        return partyGameCell
    }
    
    func waitingForHostToStartGameCell() -> WaitingTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: WaitingTableViewCell.identifier)
        let waitingCell = tableViewCell as! WaitingTableViewCell
        waitingCell.setPrompt("Waiting for Host to Start Game")
        return waitingCell
    }
    
    func startGameChangeGameButtonsCell(delegate: DoubleButtonTableViewCellDelegate) -> DoubleButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: DoubleButtonTableViewCell.identifier)
        let doubleButtonCell = tableViewCell as! DoubleButtonTableViewCell
        doubleButtonCell.setTopButtonTitle("Start Game")
        doubleButtonCell.setBottomButtonTitle("Change Game")
        doubleButtonCell.delegate = delegate
        return doubleButtonCell
    }
    
    func partyPeopleHeaderCell() -> HeaderTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)
        let headerCell = tableViewCell as! HeaderTableViewCell
        headerCell.setHeader("PARTY PEOPLE")
        headerCell.setEmoji("🎉")
        return headerCell
    }
    
    func partyPersonCell(partyPerson: PartyPerson) -> PartyPersonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: PartyPersonTableViewCell.identifier)
        let partyPersonCell = tableViewCell as! PartyPersonTableViewCell
        partyPersonCell.setName(partyPerson.name)
        partyPersonCell.setFlair(isMe: (partyPerson.name == Session.name), isHost: partyPerson.host)
        partyPersonCell.setEmoji(partyPerson.emoji)
        partyPersonCell.setPoints(partyPerson.points)
        return partyPersonCell
    }
    
    func playGameButtonCell(delegate: SingleButtonTableViewCellDelegate) -> SingleButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.identifier)
        let singleButtonCell = tableViewCell as! SingleButtonTableViewCell
        singleButtonCell.setButtonTitle("Play Game")
        singleButtonCell.delegate = delegate
        return singleButtonCell
    }
    
    func gameInstructionsCell() -> GameInstructionsTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: GameInstructionsTableViewCell.identifier)
        let gameInstructionsCell = tableViewCell as! GameInstructionsTableViewCell
        return gameInstructionsCell
    }
    
    func waitingForEveryoneToBeReadyCell() -> WaitingTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: WaitingTableViewCell.identifier)
        let waitingCell = tableViewCell as! WaitingTableViewCell
        waitingCell.setPrompt("Waiting for Everyone to be Ready")
        return waitingCell
    }
    
    func readyToPlayButtonCell(delegate: SingleButtonTableViewCellDelegate) -> SingleButtonTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: SingleButtonTableViewCell.identifier)
        let singleButtonCell = tableViewCell as! SingleButtonTableViewCell
        singleButtonCell.setButtonTitle("Ready to Play")
        singleButtonCell.delegate = delegate
        return singleButtonCell
    }
    
    func spyfallCountdownCell(delegate: GameCountdownTableViewCellDelegate) -> GameCountdownTableViewCell {
        let tableViewCell = self.dequeueReusableCell(withIdentifier: GameCountdownTableViewCell.identifier)
        let gameCountdownCell = tableViewCell as! GameCountdownTableViewCell
        gameCountdownCell.setPrompt("COUNTDOWN") // ROUND # for Wannabe
        gameCountdownCell.setMinutes(Session.game.details.duration)
        gameCountdownCell.delegate = delegate
        return gameCountdownCell
    }
    
}
