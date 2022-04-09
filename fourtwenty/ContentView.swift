//
//  ContentView.swift
//  fourtwenty
//
//  Created by Ryuji Ganaha on 4/9/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timerManager = TimerManager()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                if timerManager.modeToResume == .initial {
                    Text("Tap play to start exercise!")
                    
                } else if self.timerManager.modeToResume == .squeez {
                        Text("Squeez")
                            .font(.system(size: 20))
                        Text(String(timerManager.squeezSeconds))
                            .font(.system(size: 45))
                            .foregroundColor(.red)
                } else {
                    Text("Rest")
                        .font(.system(size: 20))
                    Text(String(timerManager.restSeconds))
                        .font(.system(size: 45))
                        .foregroundColor(.green)
                }
                
                let remainingReps = timerManager.repCount - timerManager.currentRepCount
                if remainingReps == 0 {
                    Text("Well done!")
                } else {
                    Text("\(remainingReps) more reps to go")
                }
                
                if timerManager.displayStartButton() {
                    Text("Start")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .cornerRadius(40)
                        .onTapGesture(perform: {
                            self.timerManager.exercise()
                        })
                } else if timerManager.displayResumeButton() {
                    Text("Resume")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .cornerRadius(40)
                        .onTapGesture(perform: {
                            self.timerManager.exercise()
                        })
                    
                    Text("Cancel")
                        .foregroundColor(.red)
                        .onTapGesture(perform: {
                            self.timerManager.reset()
                        })
                } else if timerManager.displayPauseButton() {
                    Text("Pause")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .cornerRadius(40)
                        .onTapGesture(perform: {
                            self.timerManager.pause()
                        })
                }
                    
            }
            .navigationBarTitle("Home", displayMode: .inline)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
