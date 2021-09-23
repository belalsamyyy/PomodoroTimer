//
//  File.swift
//  Pomodoro Timer
//
//  Created by Belal Samy on 15/08/2021.
//

import Foundation

extension Int {
    
    func twoDigits() -> String {
        return String(format: "%02d", self)
    }
    
    func toMinutes() -> Int {
        return self * 60 + 1
    }
}
