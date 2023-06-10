//
//  RecordComponentsView.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import UIKit

final class RecordComponentsView: UIView {
    private let cameraRollImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let recordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let recordButton = RecordButtonStackView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    private let recordTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        return label
    }()
    
    let changeCameraModeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "arrow.triangle.2.circlepath.camera", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 10
        blurView.layer.masksToBounds = true
        blurView.alpha = 0.7
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpRecordStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.layer.cornerRadius = 10
        self.insertSubview(blurView, at: 0)
        self.addSubview(cameraRollImageView)
        self.addSubview(upperStackView)
    }
    
    private func setUpRecordStackView() {
        upperStackView.addArrangedSubview(recordStackView)
        upperStackView.addArrangedSubview(changeCameraModeButton)
        recordStackView.addArrangedSubview(recordButton)
        recordStackView.addArrangedSubview(recordTimeLabel)
        
        cameraRollImageView.translatesAutoresizingMaskIntoConstraints = false
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraRollImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cameraRollImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cameraRollImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.15),
            cameraRollImageView.heightAnchor.constraint(equalTo: cameraRollImageView.widthAnchor),
            
            upperStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            upperStackView.leadingAnchor.constraint(equalTo: cameraRollImageView.trailingAnchor),
            upperStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            upperStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            recordButton.widthAnchor.constraint(lessThanOrEqualTo: upperStackView.widthAnchor, multiplier: 0.3),
            recordButton.heightAnchor.constraint(equalTo: recordButton.widthAnchor)
        ])
    }
}

extension RecordComponentsView {
    func setUpRecordTimerTitle(_ title: String) {
        recordTimeLabel.text = title
    }
    
    func setUpCameraRollImage(_ image: UIImage) {
        cameraRollImageView.image = image
    }
}
