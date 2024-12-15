import Foundation

struct TranslationRequest: Codable {
    let sourceLanguage: String
    let targetLanguage: String
    let sourceText: String
}

struct TranslationResponse: Codable {
    let sourceText: String
    let targetText: String
}

class TranslatorRemoteDataSource {
    private let baseUrl = "http://localhost:8080"
    
    func translateText(
        sourceLanguage: String,
        targetLanguage: String,
        sourceText: String,
        completion: @escaping (Result<TranslationResponse, Error>) -> Void
    ) {
        let url = URL(string: "\(baseUrl)/translate/text")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = TranslationRequest(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            sourceText: sourceText
        )
        
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            completion(.failure(NSError(domain: "EncodingError", code: 0, userInfo: nil)))
            return
        }
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: nil)))
                return
            }
            
            
            do {
                let translationResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                completion(.success(translationResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
