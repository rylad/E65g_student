//
//  AppDelegate.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Edited by Sean Valois on 5/3/17 --	
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var strings = [String: [[Int]]]()
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "saving")
        nc.addObserver(
            forName: name,
            object: nil,
            queue: nil) {(n) in
                let nd = n.userInfo?["dict"]
                strings =  nd as! [String:[[Int]]]
        }
        
        let dTest = strings.count
        if dTest == 0{
            print ("Defaults not set skipping...")
        }
        else {
            UserDefaults.standard.set(strings, forKey:"strings")
        }
        
        func isKeyPresentInUserDefaults(key: String) -> Bool {
            return UserDefaults.standard.object(forKey: key) != nil
        }
        
        if isKeyPresentInUserDefaults(key: "strings") == true {
            let test = UserDefaults.standard.object(forKey: "strings") as! [String : [[Int]]]
            if  test.count > 0 {
                var engine: EngineProtocol!
                engine = StandardEngine.mapNew()
                engine.loadStateDict(saveDict: UserDefaults.standard.object(forKey: "strings") as! [String : [[Int]]])
            }
        }
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

