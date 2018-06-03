//
//  AppDelegate.swift
//  Prueba_iOS
//
//  Created by Humberto Cetina on 2/25/17.
//  Copyright © 2017 Humberto Cetina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if let splitViewController = window?.rootViewController as? UISplitViewController
        {
            splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.primaryOverlay //TODO: This line is intenter to be erased by the developer
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

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        //TODO: Erase this code, the developer must put it again, all orientations only is supported on iPad and iphone plus
        if window?.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad ||
           (window?.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone && window?.traitCollection.displayScale == 3.0)
        {
            return UIInterfaceOrientationMask.all
        }
        else
        {
            return UIInterfaceOrientationMask.portrait
        }
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    // Collapse the secondary view controller onto the primary view controller.
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }
}

