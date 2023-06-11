//
//  TimerModel.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/10.
//

import Foundation
import Combine

final class TimerModel {
    @Published var secondsOfTimer: Int = 0
    private var timer: AnyCancellable?
    
    func startTimer() {
       timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.secondsOfTimer += 1
            }
    }
    
    func stopTimer() {
        secondsOfTimer = 0
        timer?.cancel()
    }
}
