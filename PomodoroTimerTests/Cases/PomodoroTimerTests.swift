//
//  PomodoroTimerTests.swift
//  PomodoroTimerTests
//
//  Created by Belal Samy on 17/08/2021.
//

import XCTest
@testable import Pomodoro_Timer

class PomodoroTimerTests: XCTestCase {
    
    var sut: PomodoroController!

    override func setUpWithError() throws {
        sut = PomodoroController()
        setUp()
    }

    override func tearDownWithError() throws {
      sut = nil
      tearDown()
    }

}
