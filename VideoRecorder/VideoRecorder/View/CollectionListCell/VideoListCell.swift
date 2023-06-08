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
        guard let date = video?.date,
              let imageData = video?.thumbnailImage,
              let thumbnailImage = UIImage(data: imageData) else { return }
        let convertedDate = dateFormatter.string(from: date)
        configuration.title = video?.title
        configuration.date = convertedDate
        configuration.savedVideo = video?.savedVideo
        configuration.thumbnailImage = thumbnailImage
        
        contentConfiguration = configuration
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let systemBackgroundView = self.subviews.first,
              let accessoryView = systemBackgroundView.subviews.first else { return }
        
        accessoryView.backgroundColor = .white
    }
}
