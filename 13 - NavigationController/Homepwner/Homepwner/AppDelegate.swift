//
//  AppDelegate.swift
//  Homepwner
//
//  Created by 전소영 on 2021/06/29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let itemsController = storyboard.instantiateViewController(identifier: "ItemTableViewController") as? ItemTableViewController {
            let navigationController = UINavigationController(rootViewController: itemsController)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            
            let itemStore = ItemStore()
            itemsController.itemStore = itemStore
        }
//        let navigationController = window?.rootViewController as? UINavigationController
//        let itemsController = navigationController?.topViewController as? ItemTableViewController
        
//        window?.rootViewController = itemsController
        
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

