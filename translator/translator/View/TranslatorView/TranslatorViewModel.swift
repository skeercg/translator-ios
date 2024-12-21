import Combine
import Foundation

class TranslatorViewModel {
    private let remoteDataSource = TranslatorRemoteDataSource()
    private let localDataSource: TranslatorLocalDataSource = {
        do {
            return try TranslatorLocalDataSource()
        } catch {
            fatalError("Failed to initialize TranslatorLocalDataSource: \(error)")
        }
    }()
    
    @Published var sourceText: String = ""
    @Published var targetText: String = ""
    
    var sourceLanguage: String = "Russian"
    var targetLanguage: String = "English"
    
    private var sourceTextSubject = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        sourceTextSubject
            .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] source in
                guard let self = self else { return }
                guard let source = source, !source.trimmingCharacters(in: .whitespaces).isEmpty else {
                    self.targetText = ""
                    return
                }
                
                self.remoteDataSource.translateText(
                    sourceLanguage: self.sourceLanguage,
                    targetLanguage: self.targetLanguage,
                    sourceText: source
                ) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            self?.localDataSource.saveTranslation(response)
                            self?.targetText = response.targetText
                        case .failure(let error):
                            print("Translation error:", error)
                            self?.targetText = ""
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func translateText() {
        sourceTextSubject.send(sourceText)
    }
    
    func translateAudio() {
        self.remoteDataSource.translateAudio(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.localDataSource.saveTranslation(response)
                    self?.sourceText = response.sourceText
                    self?.targetText = response.targetText
                case .failure(let error):
                    print("Translation error:", error)
                    self?.sourceText = ""
                    self?.targetText = ""
                }
            }
        }
    }
}
