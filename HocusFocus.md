I am building an iOS app called **Hocus Focus**, a focus timer with two unique interaction modes. Please activate the **Planner** role and generate the initial `.cursor/scratchpad.md` file according to the Educator-enhanced multi-agent rules.

---

### App Description (Product Owner Perspective)

Hocus Focus is a minimalist, distraction-resistant iOS focus timer designed for deep work. It supports two core modes:

1. **Hold-to-Focus Mode**: The user must keep their finger pressed on the screen to maintain a focus session. The timer advances only while pressure is sustained. The session ends immediately if the user lifts their finger.

2. **Stare-to-Focus Mode**: Leveraging ARKit’s eye-tracking capabilities, the app monitors whether the user is visually focused on the screen. It tracks interruptions when the user looks away and calculates an overall focus score based on gaze data.

In both modes, the app promotes intentional focus and gives real-time feedback on commitment and interruptions.

---

### Key Features

- Interactive **circular timer UI** with live feedback
- Session **activity labeling** (e.g., reading, coding)
- **Haptic feedback** for timer milestones and session completion
- Real-time **session statistics**:
  - Current streaks
  - Total focused time
  - Focus success rate (especially in Stare-to-Focus mode)
- **Session history** with analytics and filtering
- **Background execution** support so the timer can continue even if the app is minimized
- **Accessibility** support for users with touch/vision impairments
- Data persistence using **SwiftData**
- Cloud sync using **Supabase**
- UI built with **SwiftUI**, structured using clean architecture principles
- Codebase must be testable and easy to extend

---

### Acceptance Criteria

- ✅ The user can select and start either focus mode
- ✅ Timer starts when finger is pressed or eye is detected
- ✅ Timer pauses or session ends if conditions are broken
- ✅ Each session is saved with a label and timestamp
- ✅ Streaks and stats update correctly after each session
- ✅ Session history shows past records with filter/sort
- ✅ ARKit gaze tracking works on supported devices only
- ✅ App uses SwiftData for local storage
- ✅ Supabase is connected and syncing session data in the background
- ✅ Tests cover all timer logic and tracking calculations
- ✅ UI is responsive, accessible, and SwiftUI-native

---

### Learning Focus

I want to improve my understanding of:
- SwiftUI + SwiftData best practices
- Timer logic and gesture handling
- ARKit + eye tracking integration
- Clean architecture on iOS
- Data synchronization with Supabase
- Writing unit tests and testable components

Please break this down into small, testable tasks with:
- ✅ Success Criteria
- 🎯 Learning Goal
- 📘 Educator Notes with key concepts and micro-exercises

Do not execute anything yet—only plan.
