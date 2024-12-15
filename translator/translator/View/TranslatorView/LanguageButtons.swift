import UIKit

extension TranslatorView {
    func setupLanguageButtons(buttonsRegion: UIView) {
        var sourceLanguageButtonConfig = UIButton.Configuration.filled()
        sourceLanguageButtonConfig.baseBackgroundColor = UIColor(hex: 0x131313)
        sourceLanguageButtonConfig.baseForegroundColor = UIColor(hex: 0xc4c7c4)
        sourceLanguageButtonConfig.background.cornerRadius = 16
        
        let sourceLanguageButton = UIButton(configuration: sourceLanguageButtonConfig)
        sourceLanguageButton.setTitle(self.viewModel.sourceLanguage, for: .normal)
        sourceLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        sourceLanguageButton.tag = 1
        buttonsRegion.addSubview(sourceLanguageButton)
        
        var targetLanguageButtonConfig = UIButton.Configuration.filled()
        targetLanguageButtonConfig.baseBackgroundColor = UIColor(hex: 0x131313)
        targetLanguageButtonConfig.baseForegroundColor = UIColor(hex: 0xc4c7c4)
        targetLanguageButtonConfig.background.cornerRadius = 16
        
        let targetLanguageButton = UIButton(configuration: targetLanguageButtonConfig)
        targetLanguageButton.setTitle(self.viewModel.targetLanguage, for: .normal)
        targetLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        targetLanguageButton.tag = 2
        buttonsRegion.addSubview(targetLanguageButton)
        
        self.sourceLanguageButton = sourceLanguageButton
        self.targetLanguageButton = targetLanguageButton
        
        let swapButton = UIButton(type: .system)
        swapButton.setImage(UIImage(named: "swap_horiz_swap_horiz_symbol"), for: .normal)
        swapButton.tintColor = UIColor(hex: 0xc4c7c4)
        swapButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsRegion.addSubview(swapButton)
        
        NSLayoutConstraint.activate([
            sourceLanguageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            sourceLanguageButton.heightAnchor.constraint(equalToConstant: 64),
            
            targetLanguageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            targetLanguageButton.heightAnchor.constraint(equalToConstant: 64),
            
            sourceLanguageButton.topAnchor.constraint(equalTo: buttonsRegion.topAnchor, constant: 18),
            sourceLanguageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            swapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swapButton.centerYAnchor.constraint(equalTo: sourceLanguageButton.centerYAnchor),
            
            targetLanguageButton.topAnchor.constraint(equalTo: buttonsRegion.topAnchor, constant: 18),
            targetLanguageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        sourceLanguageButton.addTarget(self, action: #selector(showLanguageSelector), for: .touchUpInside)
        targetLanguageButton.addTarget(self, action: #selector(showLanguageSelector), for: .touchUpInside)
        swapButton.addTarget(self, action: #selector(swapLanguages), for: .touchUpInside)
    }
    
    @objc func showLanguageSelector(sender: UIButton) {
        switch sender.tag {
        case 1:
            let selectorView = LanguageSelectorView(
                selectorTitle: "Translate from",
                onLanguageSelected: { selectedLanguage in
                    self.viewModel.sourceLanguage = selectedLanguage
                    self.sourceLanguageButton?.setTitle(selectedLanguage, for: .normal)
                    print("Translate from: \(selectedLanguage)")
                }
            )
            
            present(selectorView, animated: true, completion: nil)
        case 2:
            let selectorView = LanguageSelectorView(
                selectorTitle: "Translate to",
                onLanguageSelected: { selectedLanguage in
                    self.viewModel.targetLanguage = selectedLanguage
                    self.targetLanguageButton?.setTitle(selectedLanguage, for: .normal)
                    print("Translate to: \(selectedLanguage)")
                }
            )
            
            present(selectorView, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc func swapLanguages(sender: UIButton) {
        var temp = self.viewModel.sourceLanguage
        self.viewModel.sourceLanguage = self.viewModel.targetLanguage
        self.viewModel.targetLanguage = temp
        
        temp = self.viewModel.sourceText
        self.viewModel.sourceText = self.viewModel.targetText
        self.viewModel.targetText = temp
        
        self.sourceLanguageButton?.setTitle(self.viewModel.sourceLanguage, for: .normal)
        self.targetLanguageButton?.setTitle(self.viewModel.targetLanguage, for: .normal)
    }
}
