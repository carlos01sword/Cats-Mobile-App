import Foundation

enum HTTPMethod: String { case get = "GET" }

struct Endpoint {
    let path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]
}

extension Endpoint {
    func makeRequest(baseURL: URL, defaultHeaders: [String: String] = [:])
        -> URLRequest?
    {
        var cleanPath = path
        if cleanPath.hasPrefix("/") { cleanPath.removeFirst() }
        var components = URLComponents(
            url: baseURL.appendingPathComponent(cleanPath),
            resolvingAgainstBaseURL: false
        )
        if !queryItems.isEmpty { components?.queryItems = queryItems }
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        (defaultHeaders.merging(headers) { _, new in new }).forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        return request
    }
}
