import Foundation

struct SupabaseService {
    static let baseURL = URL(string: "https://wqanvdjesrsyswtobyhg.supabase.co")!
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxYW52ZGplc3JzeXN3dG9ieWhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1OTIxNTQsImV4cCI6MjA2ODE2ODE1NH0.s5L-UADB-m4AQWdJYoo9Iyt5Wjv76dn6qKyQkw9u9cY "

    static func uploadSession(mode: String, label: String, timestamp: Date, duration: Double) {
        let url = URL(string: "https://wqanvdjesrsyswtobyhg.supabase.co/rest/v1/session")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "apikey")
        
        let body: [String: Any] = [
            "id": UUID().uuidString,
            "mode": mode,
            "label": label,
            "timestamp": ISO8601DateFormatter().string(from: timestamp),
            "duration": duration
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                               print("❌ Upload error: \(error.localizedDescription)")
            } else if let data = data {
                print("📦 Supabase response:")
                print(String(data: data, encoding: .utf8) ?? "No response body")
            }
        }.resume()
    }

    static func fetchSessions(completion: @escaping ([DecodableSession]) -> Void) {
        let url = URL(string: "https://wqanvdjesrsyswtobyhg.supabase.co/rest/v1/session")!
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "apikey")
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "No data")
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let sessions = try decoder.decode([DecodableSession].self, from: data)
                    DispatchQueue.main.async {
                        completion(sessions)
                    }
                } catch {
                    print("Decoding error: \(error)")
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            } else {
                print("Error fetching sessions: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }
}
