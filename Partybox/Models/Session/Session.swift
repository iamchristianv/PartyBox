//
//  Session.swift
//  Partybox
//
//  Created by Christian Villa on 5/27/18.
//  Copyright © 2018 Christian Villa. All rights reserved.
//

import Firebase
import Foundation
import SwiftyJSON

class Session {

    // MARK: - Instance Properties

    var user: User = User()

    var party: Party = Party()

    var wannabe: Wannabe = Wannabe()

    var wannabePacks: OrderedSet<WannabePack> = OrderedSet<WannabePack>()

    var games: [Any] = []

    // MARK: - Construction Functions

    static func construct(userName: String, partyName: String) -> Session {
        let session = Session()
        session.user = User.construct(name: userName)
        session.party = Party.construct(name: partyName, dataSource: session)
        session.wannabe = Wannabe.construct(dataSource: session)
        session.games.append(session.wannabe)
        return session
    }

    static func construct(userName: String, partyId: String) -> Session {
        let session = Session()
        session.user = User.construct(name: userName)
        session.party = Party.construct(id: partyId, dataSource: session)
        session.wannabe = Wannabe.construct(dataSource: session)
        session.games.append(session.wannabe)
        return session
    }

    // MARK: - Pack Functions

    func fetchPacks(callback: @escaping (String?) -> Void) {
        if self.party.details.gameId == self.wannabe.details.id &&
            self.wannabePacks.count != 0 {
            callback(nil)
        }

        let path = "\(DatabaseKey.packs.rawValue)/\(self.party.details.gameId)/\(DatabaseKey.details.rawValue)"

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [String: Any] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let json = JSON(data)

            for (_, value) in json {
                if self.party.details.gameId == self.wannabe.details.id {
                    let pack = WannabePack.construct(json: value)
                    self.wannabePacks.add(pack)
                }
            }

            callback(nil)
        })
    }

    func fetchCards(callback: @escaping (String?) -> Void) {
        if self.party.details.gameId == self.wannabe.details.id &&
            self.wannabePacks.fetch(key: self.wannabe.pack.details.id)?.cards.count != 0 {
            callback(nil)
        }

        var path = "\(DatabaseKey.packs.rawValue)/\(self.party.details.gameId)/\(DatabaseKey.cards.rawValue)"
        
        if self.party.details.gameId == self.wannabe.details.id {
            path += "/\(self.wannabe.pack.details.id)"
        }

        Database.database().reference().child(path).observeSingleEvent(of: .value, with: {
            (snapshot) in

            guard let data = snapshot.value as? [[String: Any]] else {
                callback("We ran into a problem while preparing your game\n\nPlease try again")
                return
            }

            let json = JSON(data)

            for (_, value) in json {
                if self.party.details.gameId == self.wannabe.details.id {
                    let card = WannabeCard.construct(json: value)
                    self.wannabePacks.fetch(key: self.wannabe.pack.details.id)?.cards.add(card)
                }
            }

            callback(nil)
        })
    }

}

extension Session: PartyDataSource {

    internal func partyUserName() -> String {
        return self.user.name
    }

    internal func partyUserPath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)/\(self.user.name)"
    }

    internal func partyPartyPath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.party.rawValue)"
    }

    internal func partyPartyDetailsPath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.party.rawValue)/\(PartyKey.details.rawValue)"
    }

    internal func partyPartyPeoplePath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.party.rawValue)/\(PartyKey.people.rawValue)"
    }

}

extension Session: WannabeDataSource {

    internal func wannabeUserName() -> String {
        return self.user.name
    }

    internal func wannabeUserPath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.wannabe.rawValue)/\(WannabeKey.people.rawValue)/\(self.user.name)"
    }

    internal func wannabeWannabePath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.wannabe.rawValue)"
    }

    internal func wannabeWannabeDetailsPath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.wannabe.rawValue)/\(WannabeKey.details.rawValue)"
    }

    internal func wannabeWannabePeoplePath() -> String {
        return "\(DatabaseKey.sessions.rawValue)/\(self.party.details.id)/\(SessionKey.wannabe.rawValue)/\(WannabeKey.people.rawValue)"
    }

}
