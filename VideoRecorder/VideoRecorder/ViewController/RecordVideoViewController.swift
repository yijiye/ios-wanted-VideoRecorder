//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import Combine
import AVFoundation
import UIKit

final class RecordVideoViewController: UIViewController, RecordButtonDelegate {
    enum CameraMode {
        case front
        case back
    }

    private let viewModel: RecordVideoViewModel
    private var cancellables = Set<AnyCancellable>()

    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureMovieFileOutput()
    private var videoDevice: AVCaptureDevice?
    private var videoInput: AVCaptureInput?
    
    private var outputURL: URL?
    private var timer: Timer?
    private var secondsOfTimer = 0
   
    private lazy var videoPreViewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }()
    
    private let closeButtonView: CloseButton = {
        let buttonView = CloseButton()
        
        return buttonView
    }()
    
    private let recordStackView: RecordComponentsStackView = {
        let stackView = RecordComponentsStackView()
        
        return stackView
    }()
  
    init(viewModel: RecordVideoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSession()
        recordStackView.recordButton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.stopRunning()
        }
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
            setUpCloseButton()
            setUpRecordStackView()
        
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
        guard !devices.isEmpty,
              let device = devices.first(where: { device in device.position == position }) else { return nil }
        
        return device
    }

    private func setUpCloseButton() {
        self.view.addSubview(closeButtonView)
        closeButtonView.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButtonView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            closeButtonView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            closeButtonView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func setUpRecordStackView() {
        recordStackView.changeCameraModeButton.addTarget(self, action: #selector(changeModeButtonTapped), for: .touchUpInside)
        self.view.addSubview(recordStackView)
        
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
    @objc func closeButtonTapped() {
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
    
    func tapButton(isRecording: Bool) {
        if isRecording == true {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    private func startRecording() {
        startTimer()
        outputURL = viewModel.createVideoURL()
        guard let outputURL else { return }
        videoOutput.startRecording(to: outputURL, recordingDelegate: self)
    }
    
    private func stopRecording() {
        if videoOutput.isRecording == true {
            stopTimer()
            videoOutput.stopRecording()
        }
    }
}

// MARK: Timer
extension RecordVideoViewController {
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsOfTimer += 1
            guard let title = Double(self.secondsOfTimer).format(units: [.minute, .second]) else { return }
            self.recordStackView.setUpRecordTimerTitle(title)
        }
    }
    
    private func stopTimer() {
        let reset = "00:00"
        self.secondsOfTimer = 0
        timer?.invalidate()
        self.recordStackView.setUpRecordTimerTitle(reset)
    }
}

// MARK: AVCaptureFileOutputRecordingDelegate
extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print(error?.localizedDescription as Any)
        } else {
            guard let videoRecordedURL = outputURL,
                  let videoData = try? Data(contentsOf: videoRecordedURL) else { return }
            
            let title = "영상의 제목을 입력해주세요."
            let save = "저장"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let saveAction = UIAlertAction(title: save, style: .default) { [weak self] _ in
                guard let videoTitle = alert.textFields?[0].text else { return }
                self?.fetchThumbnail(from: videoRecordedURL, videoData: videoData, title: videoTitle)
            }
            
            alert.addTextField()
            alert.addAction(saveAction)
            self.present(alert, animated: true)
        }
    }
    
    private func fetchThumbnail(from videoRecordedURL: URL, videoData: Data, title: String) {
        viewModel.generateThumbnail(from: videoRecordedURL)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] image in
                if let image {
                    guard let imageData = image.pngData() else { return }

                    let video = Video(title: "\(title).mp4", date: Date(), savedVideo: videoData, thumbnailImage: imageData)
                    self?.saveVideo(video, url: videoRecordedURL)
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveVideo(_ video: Video, url: URL) {
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
        viewModel.create(video)
    }
}




