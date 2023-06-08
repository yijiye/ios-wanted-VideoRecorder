//
//  RecordButtonStackView.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/07.
//

import UIKit

final class RecordButtonStackView: UIStackView {
    private var isRecording = false
    private var roundView: UIView?
    private var squareSide: CGFloat?
    
    private let externalCircleFactor: CGFloat = 0.1
    private let roundViewSideFactor: CGFloat = 1

    weak var delegate: RecordButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        setUpRecordButtonView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawExternalCircle()
    }
    
    private func setUpRecordButtonView() {
        drawRoundedButton()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedView(_:))))
    }

    private func drawExternalCircle() {
        let layer = CALayer()
        let radius = min(self.bounds.width, self.bounds.height)/2
        let lineWidth = externalCircleFactor * radius
        layer.frame = CGRect(x: self.bounds.size.width/2 - radius + lineWidth/2,
                             y: self.bounds.size.height/2 - radius + lineWidth/2,
                             width: radius*2 - lineWidth,
                             height: radius*2 - lineWidth)

        layer.cornerRadius = (radius*2 - lineWidth)/2
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = lineWidth
        layer.borderColor = UIColor.white.cgColor
        layer.opacity = 1

        self.layer.addSublayer(layer)
    }
    
    private func drawRoundedButton() {
        let externalCircleRadius = min(self.bounds.width, self.bounds.height) / 2
        let lineWidth = externalCircleFactor * externalCircleRadius
        let roundedButtonRadius = externalCircleRadius - lineWidth
        
        let centerX = self.bounds.width / 2
        let centerY = self.bounds.height / 2
        
        roundView = UIView(frame:
                            CGRect(x: centerX / 2 - roundedButtonRadius,
                                   y: centerY / 2 - roundedButtonRadius,
                                   width: roundedButtonRadius * 2,
                                   height: roundedButtonRadius * 2)
        )
        guard let roundView = roundView else { return }
        roundView.backgroundColor = UIColor.red
        roundView.layer.cornerRadius = roundedButtonRadius

        self.addArrangedSubview(roundView)
    }
    
    private func recordButtonAnimation() -> CAAnimationGroup? {
        squareSide = roundViewSideFactor * min(self.bounds.width, self.bounds.height)
        let transformToStopButton = CABasicAnimation(keyPath: "cornerRadius")
        guard let squareSide else { return nil }
        
        transformToStopButton.fromValue = !isRecording ? squareSide/2: 10
        transformToStopButton.toValue = !isRecording ? 10:squareSide/2

        let toSmallCircle = CABasicAnimation(keyPath: "transform.scale")

        toSmallCircle.fromValue = !isRecording ? 1: 0.65
        toSmallCircle.toValue = !isRecording ? 0.65: 1

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [transformToStopButton, toSmallCircle]
        animationGroup.duration = 0.25
        animationGroup.fillMode = CAMediaTimingFillMode.both
        animationGroup.isRemovedOnCompletion = false

        return animationGroup

    }
}

// MARK: Touch Action
extension RecordButtonStackView {
    @objc func tappedView(_ sender: UITapGestureRecognizer) {
        guard let recordButtonAnimation = self.recordButtonAnimation() else { return }
        self.roundView?.layer.add(recordButtonAnimation, forKey: "")

        isRecording = !isRecording
        delegate?.tapButton(isRecording: isRecording)
    }
}
