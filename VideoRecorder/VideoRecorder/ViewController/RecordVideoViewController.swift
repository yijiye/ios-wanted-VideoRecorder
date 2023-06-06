//
//  RecordVideoViewController.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import AVFoundation
import UIKit

final class RecordVideoViewController: UIViewController {
    private let viewModel = RecordVideoViewModel()
    
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureMovieFileOutput()
    
    private lazy var videoPreViewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer()
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        return previewLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSession()
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
        guard let videoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back),
              let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else {
            print("리턴으로 빠진")
            return }

        captureSession.sessionPreset = .high
        
        do {
            captureSession.beginConfiguration()
            
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
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
            videoPreViewLayer.session = captureSession
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
}

extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        let video = Video(title: "test", date: Date(), videoURL: outputFileURL)
        viewModel.create(video)
    }
}
