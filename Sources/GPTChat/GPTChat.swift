import Foundation

// MARK: - Models

enum GPTFinishReason: String, Codable {
    case stop = "stop"
    case length = "length"
    case contentFilter = "content_filter"
    case functionCall = "function_call"
}

struct GPTMessage: Codable {
    let role: String
    let content: String
}

struct GPTChatRequest: Codable {
    let model: String
    let messages: [GPTMessage]
}

struct GPTChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: GPTUsage
    let choices: [GPTChoice]
}

struct GPTUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct GPTChoice: Codable {
    let message: GPTMessage
    let finishReason: GPTFinishReason
    let index: Int
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case finishReason = "finish_reason"
        case index = "index"
    }
}

// MARK: - OpenAI Chat API Abstraction
@available(macOS 12.0, *)
class GPTChatAPI {
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    private let apiKey: String
    private let model: String
    
    init(apiKey: String, model: String = "gpt-3.5-turbo") {
        self.apiKey = apiKey
        self.model = model
    }
    
    @available(macOS 12.0, *)
    func chat(withMessages messages: [GPTMessage]) async throws -> GPTChatResponse {
        let chatRequest = GPTChatRequest(model: model, messages: messages)
        let jsonData = try JSONEncoder().encode(chatRequest)
        
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(GPTChatResponse.self, from: data)
    }
}
