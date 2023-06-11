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
    private var reversedList: [VideoEntity] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var recordVideoViewModel: RecordVideoViewModel
    
    init(recordVideoViewModel: RecordVideoViewModel) {
        self.recordVideoViewModel = recordVideoViewModel
        bind()
    }
    
    func bind() {
        recordVideoViewModel.createSubject
            .sink { [weak self] video in
                self?.reversedList.append(video)
                self?.updateList()
            }
            .store(in: &cancellables)
    }
    
    func updateList() {
        self.videoList = self.reversedList.reversed()
    }
    
    func read(at indexPath: IndexPath) -> VideoEntity? {
        videoList[indexPath.row]
    }
    
    func update(from id: UUID, to video: Video) {
        CoreDataManager.shared.update(from: id, to: video)
    }
    
    func delete(by id: UUID) {
        reversedList.removeAll { $0.id == id }
        updateList()
        CoreDataManager.shared.delete(by: id)
        FirebaseStorageManager.deleteVideo(id: id)
    }
    
    func readAll() {
        guard let data = CoreDataManager.shared.readAll() else { return }
        reversedList.append(contentsOf: data)
        self.updateList()
    }
    
    func deleteAll() {
        CoreDataManager.shared.deleteAll()
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
