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
    
    @Published var squeezSeconds: Int = 5
    @Published var restSeconds: Int = 5
    
    var defaultSqueezSeconds = 5
    var defaultRestSeconds = 5
    
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
            if self.squeezSeconds == 1 {
                timer.invalidate()
                self.exercise()
                self.squeezSeconds = self.defaultSqueezSeconds
            } else {
                self.squeezSeconds -= 1
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
        self.squeezSeconds = self.defaultSqueezSeconds
        self.restSeconds = self.defaultRestSeconds
        self.currentRepCount = 0
    }

    private func startSession() {
        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
    }
    
}
