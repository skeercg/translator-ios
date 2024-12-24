//
//  ViewController.swift
//  CustomCamera
//
//  Created by Alex Barbulescu on 2020-05-21.
//  Copyright © 2020 ca.alexs. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let viewModel: TranslatorViewModel
    var captureSession : AVCaptureSession!
    
    var backCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var videoOutput : AVCaptureVideoDataOutput!
    
    var takePicture = false
    var backCameraOn = true
    
    let captureImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let capturedImageView = CapturedImageView()
    
    
    init(mainViewModel: TranslatorViewModel){
        viewModel = mainViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermissions()
        setupAndStartCaptureSession()
    }
    

    func setupAndStartCaptureSession(){
        DispatchQueue.global(qos: .userInitiated).async{
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true

            self.setupInputs()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            self.setupOutput()
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs(){
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            fatalError("no back camera")
        }
        
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("could not create input device from back camera")
        }
        backInput = bInput
        if !captureSession.canAddInput(backInput) {
            fatalError("could not add back camera input to capture session")
        }
        
        captureSession.addInput(backInput)
    }
    
    func setupOutput(){
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: captureImageButton.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    @objc func captureImage(_ sender: UIButton?){
        takePicture = true
    }

}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return
        }
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
            self.capturedImageView.image = uiImage
            self.takePicture = false
            
            if let imagePath = self.saveImageToTemporaryDirectory(uiImage) {
                self.viewModel.translateImage(imagePath: imagePath)
            }
        }
    }
    
    private func saveImageToTemporaryDirectory(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let imagePath = tempDirectory.appendingPathComponent("\(UUID().uuidString).jpg")
        
        do {
            try data.write(to: imagePath)
            return imagePath.path
        } catch {
            print("Error saving image to temporary directory: \(error)")
            return nil
        }
    }
}


extension CameraViewController {
    func setupView(){
       view.backgroundColor = .black
       view.addSubview(captureImageButton)
       view.addSubview(capturedImageView)
       
       NSLayoutConstraint.activate([
        
           captureImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
           captureImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
           captureImageButton.widthAnchor.constraint(equalToConstant: 50),
           captureImageButton.heightAnchor.constraint(equalToConstant: 50),
           
           capturedImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
           capturedImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
           capturedImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
           capturedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: -70)
       ])
       captureImageButton.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
    }
    
    func checkPermissions() {
        let cameraAuthStatus =  AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch cameraAuthStatus {
          case .authorized:
            return
          case .denied:
            abort()
          case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
              if(!authorized){
                abort()
              }
            })
          case .restricted:
            abort()
          @unknown default:
            fatalError()
        }
    }
}
