import SwiftUI
import ARKit
import WebKit
import SwiftSoup


struct ReadModeView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    enum ScrollSpeed: String, CaseIterable, Identifiable {
        case slow = "Slow"
        case medium = "Medium"
        case fast = "Fast"
        
        var id: String { self.rawValue }
        var speedValue: Double {
            switch self {
            case .slow: return 2
            case .medium: return 8
            case .fast: return 16
            }
        }
    }
    
    enum ViewMode: String, CaseIterable, Identifiable {
        case normal = "Normal"
        case reader = "Reader"
        
        var id: String { self.rawValue }
    }
    
    @State private var articleURL: String = ""
    @Binding var hasStartedReading: Bool
    
    @State private var isFocused: Bool = true
    @State private var totalTime: TimeInterval = 0
    @State private var focusedTime: TimeInterval = 0
    @State private var distractionCount: Int = 0
    
    @State private var attentionTimer: Timer?
    @State private var scrollSpeed: ScrollSpeed = .medium
    @State private var showAttentionAlert: Bool = false
    @State private var showResults: Bool = false
    @State private var isPaused: Bool = false
    @State private var lastScrollOffset: CGFloat = 0
    @State private var viewMode: ViewMode = .reader
    var body: some View {
        NavigationStack {
            VStack {
                Text("Read Mode")
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, -215)
                if hasStartedReading, let url = URL(string: articleURL), !articleURL.isEmpty {
                    ZStack(alignment: .topLeading) {
                        WebView(url: url, scrollSpeed: scrollSpeed, isPaused: $isPaused, viewMode: viewMode)
                            .edgesIgnoringSafeArea(.all)
                            .onAppear {
                                startAttentionTimer()
                            }
                            .onDisappear {
                                endSession()
                            }
                        
                        Button(action: {
                            endSession()
                            hasStartedReading = false
                        }) {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }
                            .padding(12)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .padding()
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            if hasStartedReading {
                                Button(action: {
                                    endSession()
                                    hasStartedReading = false
                                }) {
                                    Image(systemName: "chevron.backward")
                                }
                            }
                        }
                    }

                    ARFaceTrackingContainer(isLooking: $isFocused)
                        .frame(width: 0, height: 0)
                        .allowsHitTesting(false)
                } else {
                    VStack(spacing: 16) {
                        Text("Paste an Article Link")
                            .font(.headline)
                        
                        HStack {
                            TextField("Enter article URL...", text: $articleURL)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.none)
                                .padding(.horizontal)
                            
                            Button(action: pasteFromClipboard) {
                                Image(systemName: "doc.on.clipboard")
                                    .font(.title2)
                                    .padding(.trailing, 8)
                                    .foregroundColor(Color(red: 0.36, green: 0.47, blue: 0.69))
                            }
                        }
                        
                        Picker("View Mode", selection: $viewMode) {
                            ForEach(ViewMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        Picker("Scroll Speed", selection: $scrollSpeed) {
                            ForEach(ScrollSpeed.allCases) { speed in
                                Text(speed.rawValue).tag(speed)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        
                        Button("Start Reading") {
                            if let _ = URL(string: articleURL), articleURL.starts(with: "http") {
                                hasStartedReading = true
                                resetTimers()
                            }
                        }
                        .disabled(articleURL.isEmpty)
                        .padding()
                        .foregroundColor(articleURL.isEmpty ? .gray : .black)
                    }
                    .padding()
                }
            }
            .alert(isPresented: $showAttentionAlert) {
                Alert(
                    title: Text("Are you still focused? Do you want to continue?"),
                    primaryButton: .default(Text("Yes")) {
                        isPaused = false
                        showAttentionAlert = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            WebViewHelper.setScrollPosition(lastScrollOffset)
                        }
                        startAttentionTimer()
                    },
                    secondaryButton: .destructive(Text("No")) {
                        endSession()
                        hasStartedReading = false
                        showAttentionAlert = false
                    }
                )
            }
            .sheet(isPresented: $showResults) {
                SessionResultsView(totalTime: totalTime, focusedTime: focusedTime, distractions: distractionCount)
            }
        }
    }
    
    func startAttentionTimer() {
        stopAttentionTimer()
        attentionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            totalTime += 1
            if isFocused {
                focusedTime += 1
            } else {
                distractionCount += 1
                WebViewHelper.getScrollPosition { offset in
                    lastScrollOffset = offset
                }
                isPaused = true
                showAttentionAlert = true
                #if targetEnvironment(simulator)
                print("HAPTIC: attention alert (simulator fallback)")
                #else
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
                #endif
                stopAttentionTimer()
            }
        }
    }
    
    func stopAttentionTimer() {
        attentionTimer?.invalidate()
        attentionTimer = nil
    }
    
    func resetTimers() {
        totalTime = 0
        focusedTime = 0
        distractionCount = 0
        isFocused = true
    }
    
    func pasteFromClipboard() {
        if let pasted = UIPasteboard.general.string,
           let _ = URL(string: pasted), pasted.starts(with: "http") {
            articleURL = pasted
        } else {
            print("Invalid or no URL in clipboard")
        }
    }
    
    func endSession() {
        stopAttentionTimer()
        print("Total Time: \(totalTime) sec")
        print("Focused Time: \(focusedTime) sec")
        print("Distraction: \(distractionCount)")
        
        sessionManager.addSession(mode: "Read Mode", label: "Reading Session", duration: focusedTime)
        
        showResults = true
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    let scrollSpeed: ReadModeView.ScrollSpeed
    @Binding var isPaused: Bool
    let viewMode: ReadModeView.ViewMode

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        WebViewHelper.webView = webView
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        switch viewMode {
        case .normal:
            uiView.load(URLRequest(url: url))
        case .reader:
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let html = String(data: data, encoding: .utf8) {
                    do {
                        let doc = try SwiftSoup.parse(html)
                        if let articleElement = try doc.select("article").first() {
                            let articleHTML = try articleElement.html()
                            let cleanHTML = """
                            <html><head>
                            <style>
                            body { font-family: -apple-system; font-size: 18px; line-height: 1.6; padding: 16px; }
                            img { max-width: 100%; height: auto; }
                            </style>
                            </head><body>
                            \(articleHTML)
                            </body></html>
                            """
                            DispatchQueue.main.async {
                                uiView.loadHTMLString(cleanHTML, baseURL: url)
                            }
                        } else {
                            DispatchQueue.main.async {
                                uiView.load(URLRequest(url: url))
                            }
                        }
                    } catch {
                        print("Parsing error: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scrollSpeed: scrollSpeed, isPaused: $isPaused)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let scrollSpeed: ReadModeView.ScrollSpeed
        @Binding var isPaused: Bool
        var scrollTimer: Timer?
        
        init(scrollSpeed: ReadModeView.ScrollSpeed, isPaused: Binding<Bool>) {
            self.scrollSpeed = scrollSpeed
            self._isPaused = isPaused
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            scrollTimer?.invalidate()
            if !self.isPaused {
                scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                    guard let self = self else { return }
                    guard !self.isPaused else { return }
                    let js = """
                    (function() {
                        var currentOffset = window.scrollY;
                        window.scrollBy(0, \(self.scrollSpeed.speedValue));
                        if (currentOffset % 500 < \(self.scrollSpeed.speedValue)) {
                            setTimeout(function(){}, 1500);
                        }
                    })();
                    """
                    webView.evaluateJavaScript(js, completionHandler: nil)
                }
            }
        }
        
        func startScrollTimer(webView: WKWebView) {
            scrollTimer?.invalidate()
            scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                guard !self.isPaused else { return }
                let js = """
                (function() {
                    var currentOffset = window.scrollY;
                    window.scrollBy(0, \(self.scrollSpeed.speedValue));
                    if (currentOffset % 500 < \(self.scrollSpeed.speedValue)) {
                        setTimeout(function(){}, 1500);
                    }
                })();
                """
                webView.evaluateJavaScript(js, completionHandler: nil)
            }
        }
        
        deinit {
            scrollTimer?.invalidate()
        }
    }
}

struct SessionResultsView: View {
    let totalTime: TimeInterval
    let focusedTime: TimeInterval
    let distractions: Int
    
    var attentionScore: Double {
        guard totalTime > 0 else { return 0 }
        return (focusedTime / totalTime) * 100
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Session Results")
                .font(.largeTitle)
                .bold()
            
            Text("Total Time: \(Int(totalTime)) seconds")
                .font(.title2)
            
            Text("Focused Time: \(Int(focusedTime)) seconds")
                .font(.title2)
            
            Text("Distractions: \(distractions)")
                .font(.title2)
            
            Text(String(format: "Attention Score: %.1f%%", attentionScore))
                .font(.title)
                .bold()
                .foregroundColor(attentionScore > 75 ? .green : .orange)
        }
        .padding()
    }
}

class WebViewHelper {
    static weak var webView: WKWebView?
    
    static func getScrollPosition(completion: @escaping (CGFloat) -> Void) {
        webView?.evaluateJavaScript("window.scrollY") { result, _ in
            if let offset = result as? CGFloat {
                completion(offset)
            } else if let doubleOffset = result as? Double {
                completion(CGFloat(doubleOffset))
            } else {
                completion(0)
            }
        }
    }
    
    static func setScrollPosition(_ offset: CGFloat) {
        webView?.evaluateJavaScript("window.scrollTo(0, \(offset))", completionHandler: nil)
    }
}
