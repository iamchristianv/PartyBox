//
//  AppDelegate.swift
//  Partybox
//
//  Created by Christian Villa on 9/30/17.
//  Copyright © 2017 Christian Villa. All rights reserved.
//

import Firebase
import SnapKit
import UIKit

struct Partybox {

    // MARK: - Instance Properties

    static let none: String = "none"

    static let null: NSNull = NSNull()

    static let zero: Int = 0

    static func randomPartyId() -> String {
        var randomId = ""

        let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

        let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

        for _ in 1...5 {
            let randomIndex = Int(arc4random())
            let randomLetter = letters[randomIndex % letters.count]
            let randomNumber = String(numbers[randomIndex % numbers.count])

            randomId += (randomIndex % 2 == 0 ? randomLetter : randomNumber)
        }

        return randomId
    }

    static func randomPersonEmoji() -> String {
        let emojis = ["😊"]

        let randomIndex = Int(arc4random()) % emojis.count
        let randomEmoji = emojis[randomIndex]

        return randomEmoji
    }

    static func randomGameId() -> String {
        let randomId = "C2D4V"

        return randomId
    }

}

enum DatabaseKey: String {

    // MARK: - Property Keys

    case parties

    case games

    case setups

}

enum SetupKey: String {

    // MARK: - Property Keys

    case parties

    case games

    case packs

    case cards

}

@UIApplicationMain
class AppDelegate: UIResponder {
    
    // MARK: - Instance Properties

    var window: UIWindow?

}

extension AppDelegate: UIApplicationDelegate {
    
    // MARK: - Application Delegate Functions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let rootViewController = MenuViewController.construct()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
