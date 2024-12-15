import UIKit
import Combine

class TranslatorView: UIViewController {
    let viewModel = TranslatorViewModel()
    
    weak var sourceLanguageTextView: UITextView?
    weak var targetLanguageTextView: UITextView?
    weak var delimiterView: UIView?
    
    private var cancellables = Set<AnyCancellable>()
    
    func setupTranslationRegion() {
        view.backgroundColor = UIColor(hex: 0x1f1f21)
        
        let translationRegion = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.75))
        translationRegion.backgroundColor = UIColor(hex: 0x131313)
        
        translationRegion.layer.cornerRadius = 64
        translationRegion.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addSubview(translationRegion)
        
        setupAppBarButtons(translationRegion: translationRegion)
        setupSourceLanguageTextField(translationRegion: translationRegion)
        setupTargetLanguageTextField(translationRegion: translationRegion)
        setupDelimiter(translationRegion: translationRegion)
        
        viewModel.$targetText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newText in
                self?.targetLanguageTextView?.text = newText
                self?.delimiterView?.isHidden = newText.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func setupButtonsRegion() {
        let buttonsRegion = UIView(frame: CGRect(x: 0, y: view.frame.height * 0.75, width: view.frame.width, height: view.frame.height * 0.25))
        buttonsRegion.backgroundColor = UIColor(hex: 0x1f1f21)
        
        view.addSubview(buttonsRegion)
        
        setupLanguageButtons(buttonsRegion: buttonsRegion)
        setupInputButtons(buttonsRegion: buttonsRegion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTranslationRegion()
        setupButtonsRegion()
    }
}
