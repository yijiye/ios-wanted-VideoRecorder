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
    let playTime: String
}
