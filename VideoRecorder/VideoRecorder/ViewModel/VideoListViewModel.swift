//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/07.
//

import Combine
import Foundation

final class VideoListViewModel {
    @Published private(set) var videoList: [VideoEntity] = []
    private var cancellables = Set<AnyCancellable>()
    
    func read(by id: UUID) -> VideoEntity? {
        CoreDataManager.shared.read(by: id)
    }
    
    func update(from id: UUID, to video: Video) {
        CoreDataManager.shared.update(from: id, to: video)
    }
    
    func delete(by id: UUID) {
        CoreDataManager.shared.delete(by: id)
    }
    
    func readAll() {
        guard let data = CoreDataManager.shared.readAll() else { return }
        videoList.append(contentsOf: data)
    }
}
