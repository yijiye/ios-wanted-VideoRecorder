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
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
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
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowPath = UIBezierPath(rect: CGRect(x: 5, y: 5, width: 60, height: 50)).cgPath
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
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
        self.backgroundColor = .white
        self.addSubview(mainStackView)

        mainStackView.addArrangedSubview(imageShadowView)
        imageShadowView.addSubview(videoImageView)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(dateLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        imageShadowView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            imageShadowView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.2),
            imageShadowView.heightAnchor.constraint(equalTo: videoImageView.widthAnchor, multiplier: 0.8),
            videoImageView.widthAnchor.constraint(equalTo: imageShadowView.widthAnchor, multiplier: 1),
            videoImageView.heightAnchor.constraint(equalTo: imageShadowView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func apply(_ configuration: VideoContentConfiguration) {
        guard let thumbnailImage = configuration.thumbnailImage else { return }
        videoImageView.image = thumbnailImage
        titleLabel.text = configuration.title
        dateLabel.text = configuration.date
    }
}
