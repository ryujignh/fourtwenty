//
//  TimeManager.swift
//  fourtwenty WatchKit Extension
//
//  Created by Ryuji Ganaha on 4/9/22.
//

import Foundation
import SwiftUI
import AVFoundation

class TimerManager: NSObject, WKExtensionDelegate, WKExtendedRuntimeSessionDelegate, ObservableObject {
    
    @Published var timerMode: TimerMode = .initial
    @Published var repCount = UserDefaults.standard.integer(forKey: "repCount")
    @Published var currentRepCount = 0
    
    @Published var exerciseSeconds: Int = 40
    @Published var restSeconds: Int = 20
    
    var defaultExerciseSeconds = 40
    var defaultRestSeconds = 20
    
    var timer = Timer()
    var session: WKExtendedRuntimeSession!
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("extendedRuntimeSessionDidStart")
    }
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("extendedRuntimeSessionWillExpire")
    }
    
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("didInvalidateWith reason=\(reason)")
    }
    
    func setRepcount(repCountSelected: Int) {
        let defaults = UserDefaults.standard
        defaults.set(repCountSelected, forKey: "repCount")
        repCount = repCountSelected
    }
    
    func exercise() {
        
        if self.currentRepCount < self.repCount {
            if timerMode == .initial {
                startSession()
            }
            
            if timerMode == .initial || timerMode == .rest {
                WKInterfaceDevice.current().play(.start)
                squeez()
            } else {
                WKInterfaceDevice.current().play(.retry)
                rest()
            }
        } else {
            WKInterfaceDevice.current().play(.success)
            reset()
        }
    }
    
    func squeez() {
        timerMode = .squeez
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.exerciseSeconds == 1 {
                timer.invalidate()
                self.exercise()
                self.exerciseSeconds = self.defaultExerciseSeconds
            } else {
                self.exerciseSeconds -= 1
            }
        })
    }
    
    func rest() {
        timerMode = .rest
        currentRepCount += 1
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.restSeconds == 1 {
                timer.invalidate()
                self.exercise()
                self.restSeconds = self.defaultRestSeconds
            } else {
                self.restSeconds -= 1
            }
        })
    }
    
    func reset() {
        timerMode = .initial
        timer.invalidate()
        self.exerciseSeconds = self.defaultExerciseSeconds
        self.restSeconds = self.defaultRestSeconds
        self.currentRepCount = 0
    }

    private func startSession() {
        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
    }
    
}
