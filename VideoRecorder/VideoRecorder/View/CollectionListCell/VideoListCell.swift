//
//  VideoListCell.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

final class VideoListCell: UICollectionViewListCell {
    var video: VideoEntity?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter
    }()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var configuration = VideoContentConfiguration().updated(for: state)
        guard let date = video?.date else { return }
        let convertedDate = dateFormatter.string(from: date)
        configuration.title = video?.title
        configuration.date = convertedDate
        configuration.savedVideo = video?.savedVideo
        
        contentConfiguration = configuration
    }
}
