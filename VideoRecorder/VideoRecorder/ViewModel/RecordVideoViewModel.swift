//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import Combine
import UIKit
import AVFoundation

final class RecordVideoViewModel {
    var createSubject = PassthroughSubject<VideoEntity, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    func create(_ video: Video) {
        CoreDataManager.shared.create(video)
        guard let data = CoreDataManager.shared.read(by: video.id) else { return }
        createSubject.send(data)
    }
    
    func generateThumbnail(from url: URL) -> Future<UIImage?, RecordingError> {
        return Future<UIImage?, RecordingError> { promise in
            DispatchQueue.global().async {
                let asset = AVAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true

                let time = CMTime(seconds: 1, preferredTimescale: 1)

                guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else {
                    promise(.failure(.thumbnail))
                    return
                }
                let thumbnailImage = UIImage(cgImage: cgImage)
                promise(.success(thumbnailImage))
            }
        }
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
