//
//  HocusFocusApp.swift
//  HocusFocus
//
//  Created by Stefania-Andra Dutu on 28/06/2025.
//

import SwiftUI

class AppSettings: ObservableObject {
    
}

@main
struct HocusFocusApp: App {
    @StateObject private var settings = AppSettings()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
