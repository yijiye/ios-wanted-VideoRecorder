//
//  VideoListViewModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/07.
//

import Combine
import Foundation
import CoreData

final class VideoListViewModel {
    @Published private(set) var videoList: [VideoEntity] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var recordVideoViewModel: RecordVideoViewModel
    
    init(recordVideoViewModel: RecordVideoViewModel) {
        self.recordVideoViewModel = recordVideoViewModel
        bind()
    }
    
    func bind() {
        recordVideoViewModel.createSubject
            .sink { [weak self] video in
                self?.videoList.append(video)
            }
            .store(in: &cancellables)
    }
    
    func read(by id: UUID) -> VideoEntity? {
        CoreDataManager.shared.read(by: id)
    }
    
    func update(from id: UUID, to video: Video) {
        CoreDataManager.shared.update(from: id, to: video)
    }
    
    func delete(by id: UUID) {
        videoList.removeAll { $0.id == id }
        CoreDataManager.shared.delete(by: id)
    }
    
    func readAll() {
        guard let data = CoreDataManager.shared.readAll() else { return }
        videoList.append(contentsOf: data)
    }
    
    func deleteAll() {
        CoreDataManager.shared.deleteAll()
    }
}
