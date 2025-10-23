import Foundation

enum DomainError: Error, LocalizedError, Equatable {
    case networkError
    case decodingError
    case unknownError
    case persistenceError
    case customError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network error occurred. Please check your internet connection."
        case .decodingError:
            return "Failed to decode the data."
        case .unknownError:
            return "An unknown error occurred."
        case .persistenceError:
            return "Failed to save or retrieve data."
        case .customError(let message):
            return message
        }
    }
}

