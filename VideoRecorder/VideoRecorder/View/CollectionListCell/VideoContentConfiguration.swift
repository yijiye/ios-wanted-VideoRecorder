//
//  VideoContentConfiguration.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

struct VideoContentConfiguration: UIContentConfiguration {
    var title: String?
    var date: String?
    var timeLabel: String?
    var thumbnailImage: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        return VideoContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> VideoContentConfiguration {
        return self
    }
}
