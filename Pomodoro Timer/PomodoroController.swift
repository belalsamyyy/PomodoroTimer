//
//  ViewController.swift
//  Pomodoro Timer
//
//  Created by Belal Samy on 15/08/2021.
//

import UIKit

class PomodoroController: UIViewController {
    
    //MARK: - Outlets
    
    // time remaining
    @IBOutlet weak var minutes_lbl: UILabel!
    @IBOutlet weak var seconds_lbl: UILabel!
    
    // tomatoes views
    @IBOutlet var tomatoes: [UIView]!
    
    // session name
    @IBOutlet weak var sessionName_lbl: UILabel!
    
    
    // buttons
    enum States {
        case start
        case pause
        case resume
        case reset
    }
    
    // start btn
    @IBOutlet weak var start_btn: UIButton!
    @IBOutlet weak var start_iv: UIImageView!
    
    // reset btn
    @IBOutlet weak var reset_btn: UIButton!
    @IBOutlet weak var reset_iv: UIImageView!
    
    // pause btn
    @IBOutlet weak var pause_btn: UIButton!
    @IBOutlet weak var pause_iv: UIImageView!
    

    //MARK: - pomodoro timer
    
    var pomodoroTimer = Timer()
    
    enum SessionsType: Int {
        case FocusTime = 25
        case ShortBreak = 5
        case LongBreak = 15
   
        var name: String {
            switch self {
            case .FocusTime:
                return "Focus Time"
            case .ShortBreak:
                return "Short Break"
            case .LongBreak:
                return "Long Break"
            }
        }
    
        var color: UIColor {
            switch self {
            case .FocusTime:
                return UIColor(red: 255/255, green: 144/255, blue: 144/255, alpha: 1) // red
            case .ShortBreak:
                return UIColor(red: 129/255, green: 221/255, blue: 164/255, alpha: 1) // green
            case .LongBreak:
                return UIColor(red: 167/255, green: 220/255, blue: 253/255, alpha: 1) // blue
            }
        }
    }
    
    
    let sessions: [SessionsType] = [.FocusTime, .ShortBreak,  // first  session
                                    .FocusTime, .ShortBreak,  // second sesssion
                                    .FocusTime, .ShortBreak,  // third  session
                                    .FocusTime, .LongBreak]   // fourth session
   
    // start point
    var finishedTomatoes = 0
    var currentSession = 0
    var timeRemaining  = 0
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // convert views into circles
        tomatoes.forEach { tomato in
            tomato.toCircle()
        }

        // reset
        updateButtons(state: .reset)
    }

    
    //MARK: - next Session
    
    func nextSession() {
        if currentSession < sessions.count {
            let current = sessions[currentSession]
            timeRemaining = current.rawValue.toMinutes() // convert sec into mins
            
            // add new tomato, if it's focus interval
            addNewTomato(to: current)
            
            view.backgroundColor = sessions[currentSession].color
            sessionName_lbl.text = current.name
            print(current.name)
            startTimer()
            currentSession += 1
            
        } else {
            
            print("You're Awesome !")
            updateButtons(state: .reset)
        }
    }
    
    //MARK: - start Timer
    
    func startTimer() {
        pomodoroTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick() {
        if timeRemaining > 0 {
            // update time remaining
            updateTimeRemaining()
        } else {
            pomodoroTimer.invalidate()
            // start next interval
            nextSession()
        }
    }
    
    func updateTimeRemaining() {
        timeRemaining -= 1
        let (minutes, seconds) = minutesAndSeconds(from: timeRemaining)
        minutes_lbl.text = "\(minutes.twoDigits())"
        seconds_lbl.text = "\(seconds.twoDigits())"
        print("Pomodoro = \(minutes.twoDigits()):\(seconds.twoDigits())")
    }
        
    func minutesAndSeconds(from seconds: Int) -> (Int, Int) {
        return (seconds / 60, seconds % 60)
    }

    
    //MARK: - add New Tomato
    func addNewTomato(to session: SessionsType) {
        if session != SessionsType.FocusTime {
            // if you finished focus time, add new tomato
            finishedTomatoes += 1
            print("\(finishedTomatoes) tomatoes")
            updateTomatoBackground()
        }
    }
    
    func updateTomatoBackground() {
        tomatoes[finishedTomatoes - 1].backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 126/255, alpha: 1) // goldish yellow
    }
    
    func resetTomatoBackground() {
        tomatoes.forEach { tomato in
            tomato.backgroundColor = .white
        }
    }
    
    
    //MARK: - buttons Actions
    
    @IBAction func startBtnPressed(_ sender: Any) {
        updateButtons(state: .start)
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        if pomodoroTimer.isValid {
            // running state
            updateButtons(state: .pause)
        } else {
            // paused state
            updateButtons(state: .resume)
        }
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        updateButtons(state: .reset)
    }
    
    
    //MARK: - update Buttons
    
    func updateButtons(state: States) {
        
        // buttons
        start_btn.layer.opacity = 0.05
        reset_btn.layer.opacity = 0.05
        pause_btn.layer.opacity = 0.05
        
        switch state {
        case .start:
            print("start ...")
            //currentSession = 0
            nextSession()
            
            start_btn.isEnabled = false
            start_iv.layer.opacity = 0
            
            pause_btn.isEnabled = true
            pause_iv.layer.opacity = 1
            pause_iv.image = UIImage(named: "button-pause")
            
            reset_btn.isEnabled = true
            reset_iv.layer.opacity = 1
            
        case .pause:
            print("pause ...")
            pomodoroTimer.invalidate() // invalidate
            pause_iv.image = UIImage(named: "button-start")
            sessionName_lbl.text = "Paused"
            
        case .resume:
            print("resume ...")
            startTimer()
            pause_iv.image = UIImage(named: "button-pause")
            sessionName_lbl.text = sessions[min(0, currentSession - 1)].name
            
        case .reset:
            print("reset ...")
            pomodoroTimer.invalidate() // invalidate
            currentSession = min(0, currentSession - 1)
            sessionName_lbl.text = "Ready to work ?!"
            view.backgroundColor = .lightGray
            
            finishedTomatoes = 0
            currentSession = 0
            timeRemaining = 25.toMinutes()
            
            updateTimeRemaining()
            resetTomatoBackground()
            
            start_btn.isEnabled = true
            start_iv.layer.opacity = 1
            
            pause_btn.isEnabled = false
            pause_iv.layer.opacity = 0
            
            reset_btn.isEnabled = false
            reset_iv.layer.opacity = 0
        }
    }
    
    
    
}

