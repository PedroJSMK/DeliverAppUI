//
//  ContentView.swift
//  DeliverAppUI
//
//  Created by PedroJSMK on 05/10/21.
//

import SwiftUI
import Firebase

@main
struct DeliveryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            Home()
        }
    }
}

 


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
}
