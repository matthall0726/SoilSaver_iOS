//
//  Plant_watering_detectorApp.swift
//  Plant watering detector
//
//  Created by Matt Hall on 1/7/24.
//

import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn


@main
struct SoilSaver: App {
    
    
    //Firebase Setup
    init() {
        FirebaseApp.configure()
        //setup()
            
    }
    
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .onAppear {
                          GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                            // Check if `user` exists; otherwise, do something with `error`
                          }
                        }
        }
    }
}
