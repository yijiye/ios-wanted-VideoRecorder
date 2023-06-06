//
//  CloseButtonStackView.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import UIKit

final class CloseButtonStackView: UIStackView {
    private let closeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: "x.circle.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.addArrangedSubview(closeButton)
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .trailing
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor, multiplier: 1.1)
        ])
    }
}
