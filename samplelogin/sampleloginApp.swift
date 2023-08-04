//
//  sampleloginApp.swift
//  samplelogin
//
//  Created by Vasisht Chinta on 7/30/23.
//

import SwiftUI
import FirebaseCore

@main
struct sampleloginApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
