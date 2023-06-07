//
//  RecordComponentsStackView.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import UIKit

final class RecordComponentsStackView: UIStackView {
    private let cameraRollImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let recordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        
        return stackView
    }()
    
    let recordButton: RecordButtonStackView = {
        let buttonStackView = RecordButtonStackView()
        
        return buttonStackView
    }()

    private let recordTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
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
        setUpImageView()
        setUpRecordStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.axis = .horizontal
        self.layer.cornerRadius = 10
        self.distribution = .equalCentering
        self.insertSubview(blurView, at: 0)
        self.addArrangedSubview(cameraRollImageView)
        self.addArrangedSubview(recordStackView)
        self.addArrangedSubview(changeCameraModeButton)
    }
    
    private func setUpImageView() {
        cameraRollImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraRollImageView.widthAnchor.constraint(equalToConstant: 100),
            cameraRollImageView.heightAnchor.constraint(equalTo: cameraRollImageView.widthAnchor)
        ])
    }
    
    private func setUpRecordStackView() {
        recordStackView.addArrangedSubview(recordButton)
        recordStackView.addArrangedSubview(recordTimeLabel)
        
        recordStackView.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            recordStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recordStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            recordButton.widthAnchor.constraint(equalTo: recordStackView.widthAnchor, multiplier: 0.7),
            recordButton.heightAnchor.constraint(equalTo: recordButton.widthAnchor, multiplier: 1)
        ])
        
    }
}

extension RecordComponentsStackView {
    func setUpRecordTimerTitle(_ title: String) {
        recordTimeLabel.text = title
    }
}
