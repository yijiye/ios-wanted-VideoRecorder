//
//  Video.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import Foundation

struct Video: Hashable {
    let id = UUID()
    let title: String
    let date: Date
    let savedVideo: Data
    let thumbnailImage: Data
    
    init(title: String, date: Date, savedVideo: Data, thumbnailImage: Data) {
        self.title = title
        self.date = date
        self.savedVideo = savedVideo
        self.thumbnailImage = thumbnailImage
    }
}
