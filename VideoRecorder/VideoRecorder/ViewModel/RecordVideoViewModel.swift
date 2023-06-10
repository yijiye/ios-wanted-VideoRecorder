//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import Combine
import Foundation

final class RecordVideoViewModel {
    @Published var timerTitle: String = "00:00"
    var createSubject = PassthroughSubject<VideoEntity, Never>()
    
    private var timerModel = TimerModel()
    private var cancellables = Set<AnyCancellable>()
   
    init() {
        bindTimer()
    }
   
    func bindTimer() {
        timerModel.$secondsOfTimer
            .map { Double($0).format(units: [.minute, .second]) }
            .compactMap { $0 }
            .assign(to: \.timerTitle, on: self)
            .store(in: &cancellables)
    }
    
    func startTimer() {
        timerModel.startTimer()
    }
    
    func stopTimer() {
        timerModel.stopTimer()
    }
    
    func create(_ video: Video) {
        CoreDataManager.shared.create(video)
//        FirebaseStorageManager.uploadVideo(video.savedVideo, videoName: video.title)
        guard let data = CoreDataManager.shared.read(by: video.id) else { return }
        createSubject.send(data)
    }
    
    func readLastVideo() -> VideoEntity? {
        return CoreDataManager.shared.readLast()
    }
    
    func createVideoURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
}
