//
//  RecordVideoViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import Combine
import Foundation

final class RecordVideoViewModel {
    func create(_ video: Video) {
        CoreDataManager.shared.create(video)
    }
}
