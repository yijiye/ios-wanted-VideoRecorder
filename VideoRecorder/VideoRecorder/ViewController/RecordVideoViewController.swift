//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import AVFoundation
import UIKit

final class RecordVideoViewController: UIViewController {
    enum CameraMode {
        case front
        case back
    }

    private let viewModel = RecordVideoViewModel()
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureMovieFileOutput()
    private var videoDevice: AVCaptureDevice?
    private var videoInput: AVCaptureInput?
   
    private lazy var videoPreViewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    private let closeButton = CloseButton()
    private let recordStackView = RecordStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSession()
        setUpCloseButton()
        setUpRecordStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func setUpSession() {
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }

        captureSession.sessionPreset = .high
        
        do {
            captureSession.beginConfiguration()
            videoDevice = selectedCamera(in: .back)
            guard let videoDevice else { return }
            videoInput = try AVCaptureDeviceInput(device: videoDevice)
            guard let videoInput else { return }
            
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput)  {
                captureSession.addInput(audioInput)
            }
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
            self.view.layer.addSublayer(videoPreViewLayer)
            self.view.addSubview(closeButton)
            self.view.addSubview(recordStackView)
            
            videoPreViewLayer.session = captureSession
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func selectedCamera(in position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        guard let device = devices.first(where: { device in device.position == position }) else { return nil }
        
        return device
    }
    
    private func startRecording() {
        let tempURL = createVidoURL()
        videoOutput.startRecording(to: tempURL, recordingDelegate: self)
    }
    
    private func createVidoURL() -> URL {
        let tempDirectory = NSTemporaryDirectory()
        let videoName = "TestVideo"
        return URL(fileURLWithPath: tempDirectory).appendingPathComponent(videoName)
    }
    
    private func stopRecording() {
        if videoOutput.isRecording == true {
            videoOutput.stopRecording()
        }
    }
    
    private func setUpCloseButton() {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setUpRecordStackView() {
        recordStackView.changeCameraModeButton.addTarget(self, action: #selector(changeModeButtonTapped), for: .touchUpInside)
        recordStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            recordStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            recordStackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2)
        ])
    }
}
// MARK: UIButton Action
extension RecordVideoViewController {
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func changeModeButtonTapped() {
        guard let input = captureSession.inputs.first(where: { input in
            guard let input = input as? AVCaptureDeviceInput else { return false }
            return input.device.hasMediaType(.video)
        }) as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = selectedCamera(in: .front)
        } else {
            newDevice = selectedCamera(in: .back)
        }
        
        do {
            guard let newDevice else { return }
            videoInput = try AVCaptureDeviceInput(device: newDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        captureSession.removeInput(input)
        guard let videoInput else { return }
        captureSession.addInput(videoInput)
    }
}


extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let video = Video(title: "test", date: Date(), videoURL: outputFileURL)
        viewModel.create(video)
    }
}
