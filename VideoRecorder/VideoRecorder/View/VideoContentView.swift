//
//  VideoContentView.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

final class VideoContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        didSet {
            apply(configuration as! VideoContentConfiguration)
        }
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let videoImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpView()
        apply(configuration as! VideoContentConfiguration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(videoImage)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(dateLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func apply(_ configuration: VideoContentConfiguration) {
        videoImage.image = configuration.videoImage
        titleLabel.text = configuration.title
        dateLabel.text = configuration.date
    }
}
