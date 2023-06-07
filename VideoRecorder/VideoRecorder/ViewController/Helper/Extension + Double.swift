//
//  Extension + Double.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/07.
//

import Foundation

extension Double {
    func format(units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [.pad]
        
        return formatter.string(from: self)
    }
}
