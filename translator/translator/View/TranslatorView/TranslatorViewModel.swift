import Combine
import Foundation

class TranslatorViewModel {
    private let remoteDataSource = TranslatorRemoteDataSource()
    
    var sourceText: String = ""
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
                guard let source = source, !source.isEmpty else {
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
}
