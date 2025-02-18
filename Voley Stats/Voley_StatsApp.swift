//
//  Voley_StatsApp.swift
//  Voley Stats
//
//  Created by Pau Hermosilla on 15/4/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//      NSSetUncaughtExceptionHandler { exception in
//              Log.error(with: Thread.callStackSymbols)
//          }
//
//          signal(SIGABRT) { _ in
//              Log.error(with: Thread.callStackSymbols)
//          }
//
//          signal(SIGILL) { _ in
//              Log.error(with: Thread.callStackSymbols)
//          }
//
//          signal(SIGSEGV) { _ in
//              Log.error(with: Thread.callStackSymbols)
//          }
//
//          signal(SIGFPE) { _ in
//              Log.error(with: Thread.callStackSymbols)
//          }
//
//          signal(SIGBUS) { _ in
//              Log.error(with: Thread.callStackSymbols)
//          }
//
//          signal(SIGPIPE) { _ in
//              Log.error(with: Thread.callStackSymbols)
//          }
    return true
  }
}

@main
struct Voley_StatsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @StateObject var user: User?
    init() {
        let navBarAppearance = UINavigationBar.appearance()
//        UserDefaults.standard.set(nil, forKey: "season")
//                    navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        pilot = .init(initial: .ListTeam)
        CustomFonts.registerFonts()
        print()
        if Team.all().isEmpty{
            DB().createDemoTeam()
            print("demo team created")
            
        }
        if !UserDefaults.standard.bool(forKey: "firstLaunch") {
            UserDefaults.standard.set(true, forKey: "mainTutorial")
            UserDefaults.standard.set(true, forKey: "captureTutorial")
            UserDefaults.standard.set(true, forKey: "fillTutorial")
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        
//        user = Auth.auth().currentUser
//        if user = user {
//            let id = user.uid
//            let email = user.email
//        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView().preferredColorScheme(.dark)
        }
    }
}
