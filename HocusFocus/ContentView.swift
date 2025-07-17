//
//  ContentView.swift
//  HocusFocus
//
//  Created by Stefania-Andra Dutu on 04/07/2025.
//
import SwiftUI
import SwiftData

enum FocusMode {
    case stare
    case hold
}

struct TimerLabelView: View {
    @ObservedObject var formatter: TimerLabelFormatter
    var seconds: Int
    var body: some View {
        Text(formatter.format(seconds: seconds))
            .font(.title)
    }
}

struct FocusDetailView: View {
    var body: some View {
        Text("Focus Session Details")
            .font(.title)
    }
}

struct ContentView: View {
    @State private var selectedMode: FocusMode? = nil
    @StateObject private var sessionManager: SessionManager
    @State private var showDetail = false
    @StateObject private var formatter = TimerLabelFormatter()
    @Environment(\.modelContext) private var modelContext

    init(modelContext: ModelContext) {
        _sessionManager = StateObject(wrappedValue: SessionManager(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let mode = selectedMode {
                    switch mode {
                    case .stare:
                        StareToFocusView(modelContext: modelContext)
                    case .hold:
                        HoldToFocusTimerView(modelContext: modelContext)
                    }
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
                    Divider().padding()
                    Text("Session History")
                        .font(.headline)
                    Button("Sync from Supabase") {
                        sessionManager.fetchSessionsFromSupabase()
                    }
                    .padding(.bottom, 4)
                    List(sessionManager.sessions) { session in
                        VStack(alignment: .leading) {
                            Text(session.label ?? "No Label")
                            Text("Mode: \(session.mode ?? "Unknown"), Duration: \(Int(session.duration))s")
                                .font(.caption)
                            Text("\(session.timestamp.formatted())")
                                .font(.caption2)
                        }
                    }
                    .frame(height: 200)
                    Divider().padding()
                    Button("Show Focus Details") {
                        showDetail = true
                    }
                    .navigationDestination(isPresented: $showDetail) {
                        FocusDetailView()
                    }
                }
            }
            .navigationTitle("Hocus Focus")
        }
    }
}

#Preview {
    ContentView(modelContext: try! ModelContainer(for: Session.self).mainContext)
}
