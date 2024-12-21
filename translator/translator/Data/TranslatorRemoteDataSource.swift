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
    
    func translateAudio(
        sourceLanguage: String,
        targetLanguage: String,
        completion: @escaping (Result<TranslationResponse, Error>) -> Void
    ) {
        let url = URL(string: "\(baseUrl)/translate/audio")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileURL = documentDirectory.appendingPathComponent("recording.m4a")
        
        guard FileManager.default.fileExists(atPath: audioFileURL.path) else {
            completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: ["message": "Audio file not found at \(audioFileURL.path)"])))
            return
        }
        
        // Create the body
        var body = Data()
        
        // Add JSON body as a form-data field
        let jsonBody: [String: String] = [
            "sourceLanguage": sourceLanguage,
            "targetLanguage": targetLanguage
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"body\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(jsonString)\r\n".data(using: .utf8)!)
        } else {
            completion(.failure(NSError(domain: "SerializationError", code: 400, userInfo: ["message": "Failed to serialize JSON body"])))
            return
        }
        
        // Add the file as a form-data field
        let fieldName = "file"
        let fileName = "Example.m4a"
        let mimeType = "audio/m4a"
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        if let fileData = try? Data(contentsOf: audioFileURL) {
            body.append(fileData)
        } else {
            completion(.failure(NSError(domain: "FileReadError", code: 400, userInfo: ["message": "Failed to read audio file"])))
            return
        }
        body.append("\r\n".data(using: .utf8)!)
        
        // Add the closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Assign the body to the request
        request.httpBody = body
        
        // Send the request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let responseData = data else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 500, userInfo: ["message": "No response from server"])))
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: responseData)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "ServerError", code: httpResponse.statusCode, userInfo: ["message": "Server responded with status \(httpResponse.statusCode)"])))
            }
        }
        
        task.resume()
    }
    
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
