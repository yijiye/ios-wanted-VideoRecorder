//
//  VideoEntity+CoreDataProperties.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//
//

import Foundation
import CoreData

extension VideoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoEntity> {
        return NSFetchRequest<VideoEntity>(entityName: "VideoEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var savedVideo: Data?
    @NSManaged public var thumbnailImage: Data?

}

extension VideoEntity : Identifiable {

}
