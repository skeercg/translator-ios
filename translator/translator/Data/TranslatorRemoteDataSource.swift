import Foundation
import Alamofire

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
        let url = "\(baseUrl)/translate/audio"
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileURL = documentDirectory.appendingPathComponent("recording.m4a")

        guard FileManager.default.fileExists(atPath: audioFileURL.path) else {
            completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: ["message": "Audio file not found at \(audioFileURL.path)"])))
            return
        }

        let parameters: [String: String] = [
            "sourceLanguage": sourceLanguage,
            "targetLanguage": targetLanguage
        ]

        AF.upload(
            multipartFormData: { multipartFormData in
                if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                    multipartFormData.append(jsonData, withName: "body")
                }

                multipartFormData.append(audioFileURL, withName: "file", fileName: "recording.m4a", mimeType: "audio/m4a")
            },
            to: url
        ).responseDecodable(of: TranslationResponse.self) { response in
            switch response.result {
            case .success(let translationResponse):
                completion(.success(translationResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func translateText(
        sourceLanguage: String,
        targetLanguage: String,
        sourceText: String,
        completion: @escaping (Result<TranslationResponse, Error>) -> Void
    ) {
        let url = "\(baseUrl)/translate/text"
        
        let requestBody = TranslationRequest(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            sourceText: sourceText
        )

        AF.request(
            url,
            method: .post,
            parameters: requestBody,
            encoder: JSONParameterEncoder.default
        ).responseDecodable(of: TranslationResponse.self) { response in
            switch response.result {
            case .success(let translationResponse):
                completion(.success(translationResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func translateImage(
        sourceLanguage: String,
        targetLanguage: String,
        imagePath: String,
        completion: @escaping (Result<TranslationResponse, Error>) -> Void
    ) {
        let url = "\(baseUrl)/translate/image"
        let imageFileURL = URL(fileURLWithPath: imagePath)
        guard FileManager.default.fileExists(atPath: imageFileURL.path) else {
            completion(.failure(NSError(domain: "FileNotFound", code: 404, userInfo: ["message": "Image file not found at \(imageFileURL.path)"])))
            return
        }

        let parameters: [String: String] = [
            "sourceLanguage": sourceLanguage,
            "targetLanguage": targetLanguage
        ]

        AF.upload(
            multipartFormData: { multipartFormData in
                if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                    multipartFormData.append(jsonData, withName: "body")
                }

                multipartFormData.append(imageFileURL, withName: "image", fileName: imageFileURL.lastPathComponent, mimeType: "image/jpeg")
            },
            to: url
        ).responseDecodable(of: TranslationResponse.self) { response in
            switch response.result {
            case .success(let translationResponse):
                completion(.success(translationResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
