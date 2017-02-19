//
//  AppDelegate.swift
//  Guardian
//
//  Created by Sergio Puleri on 2/18/17.
//  Copyright © 2017 Sergio Puleri. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    var coordinator: AppCoordinator?


    // https://developers.google.com/identity/sign-in/ios/offline-access
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Google sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        // Set client and server id
        GIDSignIn.sharedInstance().clientID = "140914815553-k3527s6ahir2lalf6fhouflga23hv9a0.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "140914815553-3rcq82sh43t05t3dfn5b5l40u2ja1qlt.apps.googleusercontent.com"
   
        GIDSignIn.sharedInstance().signOut()
        
        // Setup coordinator and root vc
        window = UIWindow()
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        window?.makeKeyAndVisible()
        
        
        
        return true
    }

    func application(application: UIApplication,
                     openURL url: URL, options: [String: AnyObject]) -> Bool {
        let options = options as NSDictionary
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                    annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
        return GIDSignIn.sharedInstance().handle(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    

    // Mark: GIDSignin Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            
            // Data for server
            let idToken = user.authentication.idToken
            let accessToken = user.authentication.accessToken
            let refreshToken = user.authentication.refreshToken
            
            
            
            let serverAuthCode = user.serverAuthCode
            
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("Signed in!")
            print("UserId: \(userId)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            // Create User with this info
            let newUser = User(name: fullName!, googleServerAuthCode: serverAuthCode!, idToken: idToken!)
            
            // Save locally
            User.encode(user: newUser)
            
            // Send token to server
            NetworkManager.sharedInstance.authWithGoogle(idToken: idToken!, accessToken: accessToken!, refreshToken: refreshToken!, serverAuthCode: serverAuthCode!)
            
            
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
                withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

