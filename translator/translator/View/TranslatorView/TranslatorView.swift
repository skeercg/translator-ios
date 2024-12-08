import UIKit

class TranslatorView: UIViewController {
    weak var sourceLanguageTextView: UITextView?
    
    func setupTranslationRegion() {
        view.backgroundColor = UIColor(hex: 0x1f1f21)
        
        let translationRegion = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.7))
        translationRegion.backgroundColor = UIColor(hex: 0x131313)
        
        translationRegion.layer.cornerRadius = 64
        translationRegion.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addSubview(translationRegion)
        
        setupSourceLanguageTextField(translationRegion: translationRegion)
        setupAppBarButtons(translationRegion: translationRegion)
    }
    
    func setupButtonsRegion() {
        let buttonsRegion = UIView(frame: CGRect(x: 0, y: view.frame.height * 0.7, width: view.frame.width, height: view.frame.height * 0.3))
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
