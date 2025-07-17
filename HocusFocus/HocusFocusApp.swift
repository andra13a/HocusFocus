//
//  HocusFocusApp.swift
//  HocusFocus
//
//  Created by Stefania-Andra Dutu on 28/06/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        ContentView(modelContext: modelContext)
    }
}

@main
struct HocusFocusApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: [Session.self])
        }
    }
}
