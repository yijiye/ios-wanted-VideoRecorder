//
//  CloseButton.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/06.
//

import UIKit

final class CloseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let image = UIImage(systemName: "x.circle.fill", withConfiguration: imageConfig)
        self.setImage(image, for: .normal)
        self.tintColor = .systemGray
    }
}
