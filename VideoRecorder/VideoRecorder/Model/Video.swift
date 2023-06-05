//
//  Video.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

struct Video: Hashable {
    let id = UUID()
    let title: String
    let date: Date
    let image: UIImage
    
    init(title: String, date: Date, image: UIImage) {
        self.title = title
        self.date = date
        self.image = image
    }
}
