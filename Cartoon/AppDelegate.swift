//
//  AppDelegate.swift
//  Cartoon
//
//  Created by Maxime Ravau on 24/03/2017.
//  Copyright © 2017 Maxime Ravau. All rights reserved.
//

import UIKit
import Parse
import Bolts
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "T6viCkf50GKQeI3A3uhFZ50zm2Lpy7IaG5DhJzgA"
            $0.clientKey = "lxkDb1ajGuo0acrqpJS5aPSaSFpSLZgRdf0qL6uT"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)

        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            
                
                if error == nil {
                    
                    UIApplication.shared.registerForRemoteNotifications()
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
                
            }
        }else{
            
            if #available(iOS 7, *){
                
                application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
                
                
                
            }else{
                
                let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
                let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
                
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                application.registerForRemoteNotifications()
            }
            
            let currentInstallation = PFInstallation.current()
            currentInstallation?.addUniqueObject("back4app", forKey: "channels")
            currentInstallation?.saveInBackground()
            
            let currentChannels = PFInstallation.current()?.channels
            
        }
        
        
        // Override point for customization after application launch.
        return true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .badge, .sound])
    }
    
   
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            completionHandler()
        }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
        PFPush.subscribeToChannel(inBackground: "globalChannel")
        
        }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        PFPush.handle(userInfo)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
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

