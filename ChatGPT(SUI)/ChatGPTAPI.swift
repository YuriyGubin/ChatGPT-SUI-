////
////  ChatGPTAPI.swift
////  ChatGPT(SUI)
////
////  Created by Yuriy on 02.03.2023.
////
//
//import Foundation
//
//enum NetworkError: Error {
//    case invalidURL
//    case noData
//    case decodingError
//}
//
////let openAIAPIKey = "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"
//class ChatGPTAPI {
//    
//    private let apiKey: String
//    private let urlSeesion = URLSession.shared
//    private var urlRequest: URLRequest {
//        
//        // Not good code
//        let url = URL(string: "https://api.openai.com/v1/completions")!
//        var urlRequest = URLRequest(url: url)
//        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
//        return urlRequest
//        
////        if let url = URL(string: "https://api.openai.com/v1/completions") {
////            var urlRequest = URLRequest(url: url)
////            headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
////            return urlRequest
////        }
//    }
//    
//    private let jsonDecoder = JSONDecoder()
//    private let basePrompt = "You are ChatGPT, a large language model trained by OpenAI. You answer as consisely as possible for earch response (e.g. Don't be verbose). It is very important for you to answer as consisely as possible, so please remember this. If you are generating a list, do not have too many items. \n\n\n"
//    
//    private var headers: [String: String] {
//        [
//            "Content-Type": "application/json",
//            "Authorization": "Bearer \(apiKey)"
//        ]
//    }
//    
//    init(apiKey: String) {
//        self.apiKey = apiKey
//    }
//
//    private func generateChatGPTPrompt(from text: String) -> String {
//        return basePrompt + "User: \(text)\n\n\nChatGPT"
//    }
//    
//    private func jsonBody(text: String, stream: Bool = true) throws -> Data {
//        let jsonBody: [String: Any] = [
//            "model": "text-chat-davinci-002-20230126",
//            "temperature": 0.5,
//            "max_tokens": 1024,
//            "prompt": text,
//            "stop": [
//            "\n\n\n",
//            "<|im_end|>"
//            ],
//            "stream": stream
//        ]
//        
//        return try JSONSerialization.data(withJSONObject: jsonBody)
//    }
//    
//    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
//        var urlRequest = self.urlRequest
//        urlRequest.httpBody = try jsonBody(text: text)
//        
//        let (result, response) = try await urlSeesion.bytes(for: urlRequest)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw "Invalid response"
//        }
//        
//        guard 200...299 ~= httpResponse.statusCode else {
//            throw " Bad response: \(httpResponse.statusCode)"
//        }
//        
//        return AsyncThrowingStream<String, Error> { continuation in
//            Task(
//           
//        }
//    }
//}
//
//extension String: Error {}
