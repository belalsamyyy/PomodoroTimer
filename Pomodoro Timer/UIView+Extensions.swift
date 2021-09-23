//
//  UIView+Extensions.swift
//  Pomodoro Timer
//
//  Created by Belal Samy on 16/08/2021.
//

import Foundation
import UIKit

extension UIView {
    func toCircle() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
