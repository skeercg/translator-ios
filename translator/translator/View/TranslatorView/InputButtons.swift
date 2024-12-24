import UIKit
import AVFoundation

extension TranslatorView: AVAudioRecorderDelegate {
    func setupInputButtons(buttonsRegion: UIView) {
        var audioButtonConfig = UIButton.Configuration.filled()
        audioButtonConfig.baseBackgroundColor = UIColor(hex: 0xa7c7fa)
        audioButtonConfig.baseForegroundColor = UIColor(hex: 0x042e70)
        audioButtonConfig.background.cornerRadius = 84
        audioButtonConfig.imagePadding = 0
        audioButtonConfig.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        audioButtonConfig.image = UIImage(named: "mic_mic_symbol")
        
        let audioButton = UIButton(configuration: audioButtonConfig)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsRegion.addSubview(audioButton)
        
        self.audioButton = audioButton
        
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
            audioButton.widthAnchor.constraint(equalToConstant: 84),
            audioButton.heightAnchor.constraint(equalToConstant: 84),
            
            audioButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            audioButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cameraButton.widthAnchor.constraint(equalToConstant: 60),
            cameraButton.heightAnchor.constraint(equalToConstant: 60),
            
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
        ])
        
        audioButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(navigateToCamera), for: .touchUpInside)
    }
    
    private func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { granted in
            if !granted {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Permission Denied", message: "Please enable microphone access in settings to use this feature.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @objc private func navigateToCamera(){
        navigationController?.pushViewController(CameraViewController(mainViewModel: viewModel), animated: true)
    }
    
    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFileURL = documentDirectory.appendingPathComponent("recording.m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            isRecording = true
            
            self.audioButton?.setImage(UIImage(named: "stop_stop_symbol"), for: .normal)
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        isRecording = false
        
        self.audioButton?.setImage(UIImage(named: "mic_mic_symbol"), for: .normal)
        self.viewModel.translateAudio()
    }
}
