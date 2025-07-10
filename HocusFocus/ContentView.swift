//
//  ContentView.swift
//  HocusFocus
//
//  Created by Stefania-Andra Dutu on 04/07/2025.
//
import SwiftUI

enum FocusMode {
    case stare
    case hold
}

struct ContentView: View {
    @State private var selectedMode: FocusMode? = nil

    var body: some View {
        VStack {
            if let mode = selectedMode {
                // Show the selected focus mode view
                switch mode {
                case .stare:
                    StareToFocusView()
                case .hold:
                    HoldToFocusTimerView()
                }
                // Add a back button to re-choose
                Button("Back") {
                    selectedMode = nil
                }
                .padding(.top)
            } else {
                // Show mode selection
                Text("Choose Focus Mode")
                    .font(.title)
                HStack(spacing: 20) {
                    Button("Stare to Focus") {
                        selectedMode = .stare
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Hold to Focus") {
                        selectedMode = .hold
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
