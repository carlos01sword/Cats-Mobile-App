import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invalidRequest
    case transport(Error)
    case serverStatus(Int)
    case decoding(Error)
    case unknown

    var description: String {
        switch self {
        case .invalidRequest: return "Invalid request"
        case .transport(let err): return "Transport error: \(err.localizedDescription)"
        case .serverStatus(let code): return "Server responded with status: \(code)"
        case .decoding(let err): return "Decoding failed: \(err.localizedDescription)"
        case .unknown: return "Unknown network error"
        }
    }
}

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async -> Result<T, NetworkError>
}

struct NetworkClient: NetworkClientProtocol {
    let baseURL: URL
    let urlSession: URLSession
    let defaultHeaders: [String: String]

    init(baseURL: URL = URL(string: "https://api.thecatapi.com/v1")!,
         urlSession: URLSession = .shared,
         defaultHeaders: [String: String] = ["x-api-key": SecretsDecoder.breedsApiKey]) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.defaultHeaders = defaultHeaders
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async -> Result<T, NetworkError> {
        guard let urlRequest = endpoint.makeRequest(baseURL: baseURL, defaultHeaders: defaultHeaders) else {
            return .failure(.invalidRequest)
        }
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                return .failure(.serverStatus(http.statusCode))
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            } catch {
                return .failure(.decoding(error))
            }
        } catch {
            return .failure(.transport(error))
        }
    }
}
