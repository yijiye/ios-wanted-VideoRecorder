//
//  VideoListCellViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/08.
//

import Foundation
import Combine

final class VideoListCellViewModel {
    @Published private(set) var video: VideoEntity
    
    init(video: VideoEntity) {
        self.video = video
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter
    }()
    
    var title: String? {
        guard let title = video.title else { return nil }
        return title
    }
    
    var date: String? {
        guard let date = video.date else { return nil }
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
    
    var thumbnailImage: Data? {
        guard let imageData = video.thumbnailImage else { return nil }
        return imageData
    }
    
}

