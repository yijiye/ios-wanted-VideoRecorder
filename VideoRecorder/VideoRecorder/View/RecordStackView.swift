//
//  RecordStackView.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import UIKit

final class RecordStackView: UIStackView {
    private let cameraRollImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let recordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
        
        return button
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
        setUpImageView()
        setUpRecordStackView()
        setUpView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.heightAnchor.constraint(equalTo: recordButton.widthAnchor)
        ])
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
}
