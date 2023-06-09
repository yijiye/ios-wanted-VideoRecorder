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
            guard let configuration = configuration as? VideoContentConfiguration else { return }
            apply(configuration)
        }
    }
    
    private let videoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let imageShadowView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowPath = UIBezierPath(rect: CGRect(x: 2, y: 2, width: 50, height: 35)).cgPath
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpView()
        guard let configuration = configuration as? VideoContentConfiguration else { return }
        apply(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(imageShadowView)
        imageShadowView.addSubview(videoImageView)
        addSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(dateLabel)
    
        imageShadowView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageShadowView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 5),
            imageShadowView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 10),
            imageShadowView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            imageShadowView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -5),
            
            videoImageView.topAnchor.constraint(equalTo: imageShadowView.topAnchor),
            videoImageView.leadingAnchor.constraint(equalTo: imageShadowView.leadingAnchor),
            videoImageView.widthAnchor.constraint(equalTo: imageShadowView.widthAnchor),
            videoImageView.heightAnchor.constraint(equalTo: videoImageView.widthAnchor, multiplier: 0.8),
            videoImageView.bottomAnchor.constraint(lessThanOrEqualTo: imageShadowView.bottomAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: imageShadowView.topAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: imageShadowView.trailingAnchor, constant: 10),
            infoStackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -5),
            infoStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func apply(_ configuration: VideoContentConfiguration) {
        guard let thumbnailImage = configuration.thumbnailImage else { return }
        videoImageView.image = thumbnailImage
        titleLabel.text = configuration.title
        dateLabel.text = configuration.date
    }
}
