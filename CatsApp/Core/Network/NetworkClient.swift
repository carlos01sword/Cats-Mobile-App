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
        case .transport(let err):
            return "Transport error: \(err.localizedDescription)"
        case .serverStatus(let code):
            return "Server responded with status: \(code)"
        case .decoding(let err):
            return "Decoding failed: \(err.localizedDescription)"
        case .unknown: return "Unknown network error"
        }
    }
}

struct NetworkClient {
    public internal(set) var requestData: (_ endpoint: Endpoint) async throws -> Data
    
    init(requestData: @escaping (_ endpoint: Endpoint) async throws -> Data) {
        self.requestData = requestData
    }
}

extension NetworkClient {
    static func live(
        baseURL: URL = URL(string: "https://api.thecatapi.com/v1")!,
        urlSession: URLSession = .shared,
        defaultHeaders: [String: String] = [
            "x-api-key": SecretsDecoder.breedsApiKey
        ]
    ) -> NetworkClient {
        NetworkClient(
            requestData: { endpoint in
                guard
                    let urlRequest = endpoint.makeRequest(
                        baseURL: baseURL,
                        defaultHeaders: defaultHeaders
                    )
                else {
                    throw NetworkError.invalidRequest
                }
                
                do {
                    let (data, response) = try await urlSession.data(for: urlRequest)
                    
                    if let http = response as? HTTPURLResponse,
                        !(200...299).contains(http.statusCode)
                    {
                        throw NetworkError.serverStatus(http.statusCode)
                    }
                    
                    return data
                    
                } catch let error as NetworkError {
                    throw error
                } catch {
                    throw NetworkError.transport(error)
                }
            }
        )
    }
}
