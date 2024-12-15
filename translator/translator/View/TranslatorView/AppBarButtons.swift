import UIKit

extension TranslatorView {
    func setupAppBarButtons(translationRegion: UIView) {
        var favoriteButtonConfig = UIButton.Configuration.borderless()
        favoriteButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        favoriteButtonConfig.image = UIImage(named: "star_star_fill1_symbol")
        favoriteButtonConfig.baseForegroundColor = UIColor(hex: 0xfefbfa)
        
        let favoriteButton = UIButton(configuration: favoriteButtonConfig)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        translationRegion.addSubview(favoriteButton)
        
        var historyButtonConfig = UIButton.Configuration.borderless()
        historyButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        historyButtonConfig.image = UIImage(named: "history_history_symbol")
        historyButtonConfig.baseForegroundColor = UIColor(hex: 0xfefbfa)
        
        let historyButton = UIButton(configuration: historyButtonConfig)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        
        translationRegion.addSubview(historyButton)
        
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: translationRegion.leadingAnchor, constant: 12),
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -12),
            
            historyButton.trailingAnchor.constraint(equalTo: translationRegion.trailingAnchor, constant: -12),
            historyButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -12),
        ])
        
        historyButton.addTarget(self, action: #selector(openHistory), for: .touchUpInside)
    }
    
    @objc private func openHistory() {
        navigationController?.pushViewController(SavedTranslationsViewController(), animated: true)
    }
}
