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
        
        return stackView
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image = UIImage(systemName: "record.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .red
        
        return button
    }()
    
    private let recordTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let changeCameraModeButton: UIButton = {
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
        setUpRecordStackView()
        setUpView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpRecordStackView() {
        recordStackView.addArrangedSubview(recordButton)
        recordStackView.addArrangedSubview(recordTimeLabel)
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
