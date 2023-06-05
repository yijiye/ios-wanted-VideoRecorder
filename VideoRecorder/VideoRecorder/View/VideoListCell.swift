//
//  VideoListCell.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

final class VideoListCell: UICollectionViewListCell {
    var video: Video?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var configuration = VideoContentConfiguration().updated(for: state)
        configuration.title = video?.title
        configuration.date = video?.date.description
        configuration.videoImage = video?.image
        
        contentConfiguration = configuration
    }
}
