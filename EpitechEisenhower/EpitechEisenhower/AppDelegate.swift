//
//  AppDelegate.swift
//  EpitechEisenhower
//
//  Created by fauquette fred on 25/09/17.
//  Copyright © 2017 Epitech. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{
    var window: UIWindow?
    
    
    func logToFirebase(credential : AuthCredential) {
        Auth.auth().signIn(with : credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            let storyboard = UIStoryboard(name : "Main", bundle : nil)
            let viewController : HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let rootViewController = self.window!.rootViewController as! UINavigationController
            rootViewController.pushViewController(viewController, animated : true)
            self.tryAddUserToDB()
        }
    }
    
    
    // Google sign in function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        print("before firebase login")
        logToFirebase(credential: credential)
        //tryAddUserToDB()
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }

   
    
    func application(_ application: UIApplication, open url: URL, sourceApplication : String?, annotation: Any) -> Bool {
            let facebook = FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                                 open: url,
                                                                                 sourceApplication: sourceApplication,
                                                                                 annotation: annotation)
            return facebook || GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:sourceApplication,
                                                     annotation: annotation)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp()
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

    func tryAddUserToDB() {
        let currentUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        let refDB = Database.database().reference()
        print(userID!)
        print(currentUser?.displayName)
        refDB.child("users").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            if (value == nil) {
                refDB.child("users").child(userID!).setValue(["name" : currentUser?.displayName, "email": currentUser?.email])
            }
            else {
                print(currentUser?.displayName)
            }
            
            
        })
    }
}

