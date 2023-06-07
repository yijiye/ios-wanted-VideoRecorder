//
//  CoreDataManager.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() { }
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
    
    func create(_ video: Video) {
        guard let context,
              let entity = NSEntityDescription.entity(forEntityName: "VideoEntity", in: context),
              let storage = NSManagedObject(entity: entity, insertInto: context) as? VideoEntity else { return }
        
        setValue(at: storage, data: video)
        save()
    }
    
    func read(by id: UUID) -> VideoEntity? {
        guard let context else { return nil }
        let request = NSFetchRequest<NSManagedObject>(entityName: "VideoEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let data = try context.fetch(request)
            return data.first as? VideoEntity
        } catch {
            return nil
        }
    }
    
    func readAll() -> [VideoEntity]? {
        guard let context else { return nil }
        
        do {
            let data = try context.fetch(VideoEntity.fetchRequest())
            return data
        } catch {
            return nil
        }
    }
    
    func update(from id: UUID, to video: Video) {
        guard let currentVideo = read(by: id) else { return }
        
        setValue(at: currentVideo, data: video)
        save()
    }
    
    func delete(by id: UUID) {
        guard let context else { return }
        let request: NSFetchRequest<NSFetchRequestResult> = VideoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(delete)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setValue(at target: VideoEntity, data: Video) {
        target.setValue(data.id, forKey: "id")
        target.setValue(data.title, forKey: "title")
        target.setValue(data.date, forKey: "date")
        target.setValue(data.savedVideo, forKey: "savedVideo")
    }
    
    private func save() {
        guard let context else { return }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
