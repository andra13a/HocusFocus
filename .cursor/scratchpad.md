## Background and Motivation
Hocus Focus is a minimalist, distraction-resistant iOS focus timer designed for deep work. It features two unique interaction modes: Hold-to-Focus (requiring continuous touch) and Stare-to-Focus (using ARKit eye-tracking). The app aims to promote intentional focus, provide real-time feedback, and help users build better work habits. This project is also an opportunity to learn best practices in SwiftUI, SwiftData, ARKit, clean architecture, and test-driven development.

## Key Challenges and Analysis
- Implementing reliable timer logic and gesture handling for both touch and gaze modes
- Integrating ARKit eye-tracking and handling device compatibility
- Ensuring accessibility for users with touch/vision impairments
- Persisting and syncing session data locally (SwiftData) and in the cloud (Supabase)
- Designing a clean, testable, and extensible SwiftUI architecture
- Providing real-time feedback and analytics (streaks, stats, history)
- Supporting background execution and robust error handling

## High-Level Task Breakdown
- [ ] Task 1: Set up a new SwiftUI project with clean architecture scaffolding
  - ✅ Success Criteria: Project builds and runs a basic SwiftUI view; folder structure supports separation of concerns.
  - 🎯 Learning Goal: Understand project setup, SwiftUI app lifecycle, and clean architecture basics.
  - 📘 Educator Notes: 
    - SwiftUI apps start with an @main struct conforming to App.
    - Clean architecture separates UI, business logic, and data layers.
    - Try creating folders for Views, Models, ViewModels, and Services.
    - **Exercise:** Create a new SwiftUI view and display "Hello, Hocus Focus!".
    - **Question:** Why is separation of concerns important in app design?

- [ ] Task 2: Implement the circular timer UI component
  - ✅ Success Criteria: A circular timer is visible and animates as time passes.
  - 🎯 Learning Goal: Learn about SwiftUI drawing, animation, and state management.
  - 📘 Educator Notes:
    - Use `Circle`, `Trim`, and `rotationEffect` for circular progress.
    - Use `@State` to update timer progress.
    - **Exercise:** Animate a circle filling up over 10 seconds.
    - **Question:** How does SwiftUI's state system trigger UI updates?

- [ ] Task 3: Add Hold-to-Focus mode (touch gesture starts/stops timer)
  - ✅ Success Criteria: Timer only runs while finger is pressed; session ends if lifted.
  - 🎯 Learning Goal: Practice gesture handling and timer control in SwiftUI.
  - 📘 Educator Notes:
    - Use `LongPressGesture` or `DragGesture` for continuous touch.
    - Use `Timer.publish` or `DispatchSourceTimer` for timing.
    - **Example:**
      ```swift
      struct HoldToFocusButton: View {
          @State private var isHolding = false
          var body: some View {
              Circle()
                  .fill(isHolding ? Color.green : Color.gray)
                  .frame(width: 100, height: 100)
                  .gesture(
                      DragGesture(minimumDistance: 0)
                          .onChanged { _ in isHolding = true }
                          .onEnded { _ in isHolding = false }
                  )
          }
      }
      ```
    - **Micro-Exercise:**
      Try making a button or circle that prints "Holding!" to the console while pressed, and "Released!" when the finger is lifted.
    - **Guiding Question:**
      What's the difference between a tap and a long press in SwiftUI?

- [ ] Task 4: Add Stare-to-Focus mode (ARKit eye-tracking)
  - ✅ Success Criteria: Timer runs only when user's gaze is detected on screen; session ends if gaze leaves.
  - 🎯 Learning Goal: Integrate ARKit, understand device capability checks, and basic eye-tracking.
  - 📘 Educator Notes:
    - **Concept Summary:**
      - ARKit can track where a user is looking using the TrueDepth camera (available on devices with Face ID).
      - Not all devices support ARKit eye-tracking. You must check for support before enabling this feature.
      - Use `ARSession` and `ARFaceTrackingConfiguration` to start a session and receive face/gaze data.
    - **Example:**
      ```swift
      import ARKit
      // Check if device supports face tracking
      if ARFaceTrackingConfiguration.isSupported {
          print("Face tracking is supported!")
      } else {
          print("Face tracking is NOT supported on this device.")
      }
      ```
      - You can use `ARSessionDelegate` to receive updates about the user's face and gaze.
    - **Micro-Exercise:**
      Try writing a function that checks if ARKit face tracking is supported and prints a message to the console.
    - **Guiding Question:**
      What privacy considerations exist for eye-tracking features? (Think about user consent, data storage, and transparency.)

- [ ] Task 5: Persist session data locally with SwiftData
  - ✅ Success Criteria: Each session (mode, label, timestamp, duration) is saved and can be loaded.
  - 🎯 Learning Goal: Learn about data models, persistence, and SwiftData basics.
  - 📘 Educator Notes:
    - Define a Session model struct/class.
    - Use SwiftData (or CoreData if SwiftData unavailable) for CRUD operations.
    - **Exercise:** Save and load a simple object to local storage.
    - **Question:** What are the trade-offs between local and cloud storage?

- [ ] Task 6: Sync session data with Supabase
  - ✅ Success Criteria: Session data is uploaded and synced with a Supabase backend.
  - 🎯 Learning Goal: Understand cloud sync, REST APIs, and authentication basics.
  - 📘 Educator Notes:
    - Supabase provides a Postgres backend with RESTful API.
    - Use URLSession or a Supabase Swift SDK.
    - **Exercise:** Make a test API call to Supabase.
    - **Question:** How do you handle sync conflicts between local and remote data?

- [ ] Task 7: Add session history and analytics UI
  - ✅ Success Criteria: User can view, filter, and sort past sessions; stats update correctly.
  - 🎯 Learning Goal: Practice list views, filtering, and computed properties in SwiftUI.
  - 📘 Educator Notes:
    - Use `List` and `ForEach` for history.
    - Use computed properties for stats (streaks, totals).
    - **Exercise:** Display a list of mock sessions and calculate a total.
    - **Question:** How can you make analytics accessible to all users?

- [ ] Task 8: Write unit and UI tests for timer, gesture, and data logic
  - ✅ Success Criteria: All core logic is covered by passing tests.
  - 🎯 Learning Goal: Practice TDD and testable SwiftUI design.
  - 📘 Educator Notes:
    - Use XCTest for logic, and SwiftUI previews for UI.
    - **Exercise:** Write a test for a timer function.
    - **Question:** Why is automated testing important for refactoring?

- [ ] Task 9: Add haptic feedback and accessibility improvements
  - ✅ Success Criteria: Haptics trigger on milestones; UI is accessible for all users.
  - 🎯 Learning Goal: Learn CoreHaptics and SwiftUI accessibility modifiers.
  - 📘 Educator Notes:
    - Use .accessibilityLabel, VoiceOver, and CoreHaptics.
    - **Exercise:** Add a haptic to a button press.
    - **Question:** What are best practices for accessible SwiftUI apps?

## Project Status Board
- [ ] Task 1: Set up a new SwiftUI project with clean architecture scaffolding
- [ ] Task 2: Implement the circular timer UI component
- [ ] Task 3: Add Hold-to-Focus mode (touch gesture starts/stops timer)
- [ ] Task 4: Add Stare-to-Focus mode (ARKit eye-tracking)
- [ ] Task 5: Persist session data locally with SwiftData
- [ ] Task 6: Sync session data with Supabase
- [ ] Task 7: Add session history and analytics UI
- [ ] Task 8: Write unit and UI tests for timer, gesture, and data logic
- [ ] Task 9: Add haptic feedback and accessibility improvements

## Executor's Feedback or Assistance Requests

## Lessons 