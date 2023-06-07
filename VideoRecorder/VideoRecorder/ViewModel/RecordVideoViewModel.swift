//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import Combine
import Foundation

final class RecordVideoViewModel {
    var createSubject = PassthroughSubject<VideoEntity, Never>()
    
    func create(_ video: Video) {
        CoreDataManager.shared.create(video)
        guard let data = CoreDataManager.shared.read(by: video.id) else { return }
        createSubject.send(data)
    }
}
