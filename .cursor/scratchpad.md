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
### Task 1: Educator Phase

**Concept Summary:**
- SwiftUI App Entry Point: Every SwiftUI app starts with an `@main` struct conforming to `App`. This is where your app's lifecycle begins.
- Clean Architecture: Separates your code into layers (UI, business logic, data) for better maintainability and testability.
- Folder Structure: Common folders are `Views`, `Models`, `ViewModels`, and `Services`.

**Example: Minimal SwiftUI App**
```swift
import SwiftUI

@main
struct HocusFocusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, Hocus Focus!")
    }
}
```

**Pre-task Micro-Exercise:**
- Create a new SwiftUI view (e.g., `ContentView.swift`) and display `"Hello, Hocus Focus!"` on the screen.

**Guiding Question:**
- Why is separation of concerns important in app design?

**Quick Quiz:**
1. What does the `@main` attribute do in a SwiftUI app?
2. What are the benefits of organizing your code into `Views`, `Models`, and `ViewModels`?

### Task 3: Educator Phase

**Concept Summary:**
- SwiftUI provides gesture recognizers like `LongPressGesture` and `DragGesture` to detect and respond to user touch events.
- You can use `@State` to track whether the user is pressing and control the timer's state.
- The timer should only run while the user is pressing and stop/reset when released.

**Example: Hold-to-Focus Button**
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

**Pre-task Micro-Exercise:**
- Make a button or circle that prints "Holding!" to the console while pressed, and "Released!" when the finger is lifted.

**Guiding Question:**
- What's the difference between a tap and a long press in SwiftUI?

**Quick Quiz:**
1. How does `DragGesture` differ from `LongPressGesture`?
2. Why is `@State` important for updating the UI in response to gestures?
3. How would you reset the timer if the user lifts their finger before the session is complete?

### Task 4: Educator Phase

**Concept Summary:**
- ARKit enables advanced camera-based features, including face and eye tracking, on supported iOS devices (those with a TrueDepth camera).
- You can use `ARFaceTrackingConfiguration` to access face and gaze data, but you must check device support first.
- Eye-tracking data can be used to determine if the user is looking at the screen, enabling a "stare-to-focus" mode.

**Example: Check for ARKit Face Tracking Support**
```swift
import ARKit

if ARFaceTrackingConfiguration.isSupported {
    print("Face tracking is supported!")
} else {
    print("Face tracking is NOT supported on this device.")
}
```

**Pre-task Micro-Exercise:**
- Write a function that checks if ARKit face tracking is supported and prints a message to the console.

**Guiding Question:**
- What privacy considerations exist for eye-tracking features? (Think about user consent, data storage, and transparency.)

**Quick Quiz:**
1. What devices support ARKit face and eye tracking?
2. How can you detect if the user is looking at the screen using ARKit?
3. Why is it important to check for device support before enabling ARKit features?

### Task 5: Educator Phase

**Concept Summary:**
- Persistence means saving data so it remains available after the app is closed or the device is restarted.
- SwiftData (or CoreData) is Apple’s framework for local data storage, allowing you to save, fetch, update, and delete objects.
- A data model defines the structure of the data you want to store (e.g., a Session with mode, label, timestamp, duration).
- CRUD stands for Create, Read, Update, Delete—the four basic operations for persistent data.

**Example: Simple Session Model and Persistence**
```swift
import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    let mode: String
    let label: String
    let timestamp: Date
    let duration: TimeInterval
}

// Saving a Session (UserDefaults example for simplicity):
func saveSession(_ session: Session) {
    var sessions = loadSessions()
    sessions.append(session)
    if let data = try? JSONEncoder().encode(sessions) {
        UserDefaults.standard.set(data, forKey: "sessions")
    }
}

func loadSessions() -> [Session] {
    if let data = UserDefaults.standard.data(forKey: "sessions"),
       let sessions = try? JSONDecoder().decode([Session].self, from: data) {
        return sessions
    }
    return []
}
```
> For production, use SwiftData or CoreData for more robust storage.

**Pre-task Micro-Exercise:**
- Define a simple `Session` struct with the required properties.
- Write a function to save a session to local storage and another to load all sessions.

**Guiding Question:**
- What are the trade-offs between local and cloud storage?
  - Local storage is fast, private, and works offline, but data is lost if the device is lost or the app is deleted.
  - Cloud storage enables sync and backup, but requires internet and has privacy/security considerations.

**Quick Quiz:**
1. What is a data model, and why is it important for persistence?
   - A data model defines the structure of the data you want to store. It ensures consistency and makes it easier to save, load, and manage data.
2. What does CRUD stand for?
   - Create, Read, Update, Delete.
3. Why might you choose SwiftData/CoreData over UserDefaults for session storage?
   - SwiftData/CoreData is designed for complex, structured data and supports relationships, queries, and large datasets, while UserDefaults is best for small, simple data.

### Task 6: Educator Phase

**Concept Summary:**
- Cloud sync allows your app to store and retrieve data from a remote server, enabling backup, multi-device access, and collaboration.
- Supabase is an open-source backend-as-a-service that provides a Postgres database, RESTful API, authentication, and more.
- To sync data, your app will need to make HTTP requests (using `URLSession` or a Supabase Swift SDK) to send and fetch session data.
- You must handle authentication, network errors, and potential conflicts between local and remote data.

**Example: Making a Simple API Call to Supabase**
```swift
import Foundation

let url = URL(string: "https://your-project.supabase.co/rest/v1/sessions")!
var request = URLRequest(url: url)
request.httpMethod = "GET"
request.addValue("Bearer YOUR_SUPABASE_API_KEY", forHTTPHeaderField: "Authorization")

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let data = data {
        print(String(data: data, encoding: .utf8) ?? "No data")
    } else if let error = error {
        print("Error: \(error)")
    }
}
task.resume()
```

**Pre-task Micro-Exercise:**
- Try writing a function that fetches data from a public API (e.g., https://jsonplaceholder.typicode.com/todos/1) and prints the result to the console.

**Guiding Question:**
- What are the main challenges when syncing data between a local database and a cloud backend?

**Quick Quiz:**
1. What is Supabase, and what services does it provide?
2. Why do you need to handle authentication when syncing with a cloud backend?
3. What is a RESTful API, and how does your app communicate with it?
4. How would you resolve a conflict if a session is changed both locally and in the cloud?

### Task 7: Educator Phase

**Concept Summary:**
- A good session history and analytics UI helps users reflect on their focus habits and progress.
- In SwiftUI, you can use `List` and `ForEach` to display collections of data, and computed properties to calculate statistics (like total time, streaks, or averages).
- Separating session history into its own view keeps the main interface clean and focused, improving user experience and scalability.
- Navigation in SwiftUI is handled with navigation links or destinations, allowing users to move between the main page and detailed history views.

**Example: Displaying Session History in a Dedicated View**
```swift
struct SessionHistoryView: View {
    @ObservedObject var sessionManager: SessionManager
    var body: some View {
        List(sessionManager.sessions) { session in
            VStack(alignment: .leading) {
                Text(session.label ?? "No Label")
                Text("Mode: \(session.mode ?? "Unknown"), Duration: \(Int(session.duration))s")
                    .font(.caption)
                Text("\(session.timestamp.formatted())")
                    .font(.caption2)
            }
        }
        .navigationTitle("Session History")
    }
}
```

**Pre-task Micro-Exercise:**
- Create a mock list of sessions and display them in a SwiftUI `List`.
- Add a computed property to calculate the total focus time from all sessions.

**Guiding Question:**
- How can you design your session history UI to be both informative and uncluttered for the user?

**Quick Quiz:**
1. What SwiftUI view is commonly used to display a scrollable list of items?
2. Why is it beneficial to move session history to a separate view instead of showing it on the main page?
3. How can you calculate statistics (like total duration) from your session data in SwiftUI?
4. What are some ways to make analytics accessible and meaningful to all users?
