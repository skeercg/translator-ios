import UIKit

extension TranslatorView {
    func setupLanguageButtons(buttonsRegion: UIView) {
        var sourceLanguageButtonConfig = UIButton.Configuration.filled()
        sourceLanguageButtonConfig.baseBackgroundColor = UIColor(hex: 0x131313)
        sourceLanguageButtonConfig.baseForegroundColor = UIColor(hex: 0xc4c7c4)
        sourceLanguageButtonConfig.background.cornerRadius = 16
        
        let sourceLanguageButton = UIButton(configuration: sourceLanguageButtonConfig)
        sourceLanguageButton.setTitle("Russian", for: .normal)
        sourceLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsRegion.addSubview(sourceLanguageButton)
        
        var targetLanguageButtonConfig = UIButton.Configuration.filled()
        targetLanguageButtonConfig.baseBackgroundColor = UIColor(hex: 0x131313)
        targetLanguageButtonConfig.baseForegroundColor = UIColor(hex: 0xc4c7c4)
        targetLanguageButtonConfig.background.cornerRadius = 16
        
        let targetLanguageButton = UIButton(configuration: targetLanguageButtonConfig)
        targetLanguageButton.setTitle("English", for: .normal)
        targetLanguageButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsRegion.addSubview(targetLanguageButton)
        
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
    }
}
