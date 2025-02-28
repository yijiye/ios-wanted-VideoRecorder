//
//  VideoListCell.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit
import Combine

final class VideoListCell: UICollectionViewListCell {
    private var viewModel: VideoListCellViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var configuration = VideoContentConfiguration().updated(for: state)
        guard let title = viewModel?.title,
              let date = viewModel?.date,
              let imageData = viewModel?.thumbnailImage,
              let thumbnailImage = UIImage(data: imageData),
              let time = viewModel?.time else { return }
        
        configuration.title = title
        configuration.date = date
        configuration.thumbnailImage = thumbnailImage
        configuration.timeLabel = time
        
        contentConfiguration = configuration
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    private func bind() {
        viewModel?.$video
            .sink { [weak self] _ in
                self?.setNeedsUpdateConfiguration()
            }
            .store(in: &cancellables)
    }
    
    func configureCell(with video: VideoEntity) {
        viewModel = VideoListCellViewModel(video: video)
        bind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let systemBackgroundView = self.subviews.first,
              let accessoryView = systemBackgroundView.subviews.first else { return }

        accessoryView.backgroundColor = .white
    }
}
