import UIKit

extension TranslatorView {
    func setupInputButtons(buttonsRegion: UIView) {
        var micButtonConfig = UIButton.Configuration.filled()
        micButtonConfig.baseBackgroundColor = UIColor(hex: 0xa7c7fa)
        micButtonConfig.baseForegroundColor = UIColor(hex: 0x042e70)
        micButtonConfig.background.cornerRadius = 84
        micButtonConfig.imagePadding = 0
        micButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        micButtonConfig.image = UIImage(named: "mic_mic_symbol")
        
        let micButton = UIButton(configuration: micButtonConfig)
        micButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsRegion.addSubview(micButton)
        
        
        var cameraButtonConfig = UIButton.Configuration.filled()
        cameraButtonConfig.baseBackgroundColor = UIColor(hex: 0x034a78)
        cameraButtonConfig.baseForegroundColor = UIColor(hex: 0xc2e7ff)
        cameraButtonConfig.background.cornerRadius = 84
        cameraButtonConfig.imagePadding = 0
        cameraButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        cameraButtonConfig.image = UIImage(named: "photo_camera_photo_camera_symbol")
        
        let cameraButton = UIButton(configuration: cameraButtonConfig)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsRegion.addSubview(cameraButton)
        
        
        NSLayoutConstraint.activate([
            micButton.widthAnchor.constraint(equalToConstant: 84),
            micButton.heightAnchor.constraint(equalToConstant: 84),
            
            micButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            micButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cameraButton.widthAnchor.constraint(equalToConstant: 60),
            cameraButton.heightAnchor.constraint(equalToConstant: 60),
            
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
        ])
    }
}
