//
//  TimeManager.swift
//  fourtwenty
//
//  Created by Ryuji Ganaha on 4/9/22.
//

import Foundation


import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    
    var timerMode: TimerMode = .initial
    @Published var modeToResume: TimerMode = .initial
//    @Published var repCount = UserDefaults.standard.integer(forKey: "repCount")
    @Published var repCount = 5
    @Published var currentRepCount = 0
    
    @Published var squeezSeconds: Int = 5
    @Published var restSeconds: Int = 5
    
    @Published var pausable = false
    
    var defaultSqueezSeconds = 5
    var defaultRestSeconds = 5
    
    var timer = Timer()
    
//    start
//    pause
//    save current second
//    stop timer
//    resume
//    start timer with saved second
    
    
//    func setRepcount(repCountSelected: Int) {
//        let defaults = UserDefaults.standard
//        defaults.set(repCountSelected, forKey: "repCount")
//        repCount = repCountSelected
//    }
    
    func exercise() {
//        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if self.currentRepCount < self.repCount {
            
            if timerMode == .initial || timerMode == .rest {
                squeez()
                
            } else if timerMode == .paused {
                if modeToResume == .squeez {
                    squeez()
                } else {
                    rest()
                }
            } else {
                rest()
            }
        } else {
            reset()
        }
    }
    
    func squeez() {
        timerMode = .squeez
        modeToResume = .squeez
        pausable = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.squeezSeconds == 1 {
                self.switchMode()
            } else {
                self.squeezSeconds -= 1
            }
        })
    }
    
    func rest() {
        timerMode = .rest
        modeToResume = .rest
        pausable = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.restSeconds == 1 {
                self.currentRepCount += 1
                self.switchMode()
            } else {
                self.restSeconds -= 1
            }
        })
    }
    
    func switchMode() {
        timer.invalidate()
        self.squeezSeconds = self.defaultSqueezSeconds
        self.restSeconds = self.defaultRestSeconds
        self.exercise()
    }
    
    func reset() {
        timerMode = .initial
        modeToResume = .initial
        timer.invalidate()
        self.squeezSeconds = self.defaultSqueezSeconds
        self.restSeconds = self.defaultRestSeconds
        self.currentRepCount = 0
    }
    
    func pause() {
        timerMode = .paused
        pausable = false
        timer.invalidate()
    }
    
    func displayStartButton() -> Bool {
        timerMode == .initial
    }
    
    func displayResumeButton() -> Bool {
        timerMode == .paused
    }
    
    func displayPauseButton() -> Bool {
        timerMode == .squeez || timerMode == .rest
    }
//
//    func displayRepeatButton() -> Bool {
//        timerMode == . || timerMode == .rest
//    }
    
}
