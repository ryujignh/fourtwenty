//
//  ContentView.swift
//  fourtwenty WatchKit Extension
//
//  Created by Ryuji Ganaha on 4/9/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timerManager = TimerManager()
    
    @State var repPickerIndex = 3 // Default to 4 reps
    let repCounts = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let repCountIndex = UserDefaults.standard.integer(forKey: "repCountIndex")
    
    var body: some View {
        VStack {
            
            if self.timerManager.timerMode == .initial {
                Picker(selection: $repPickerIndex, label: Text("Select reps")) {
                    ForEach(0 ..< repCounts.count) {
                        Text("\(self.repCounts[$0]) reps")
                    }
                }
                Button(action: {
                    self.timerManager.setRepcount(repCountSelected: self.repCounts[self.repPickerIndex])
                    self.timerManager.exercise()
                }) {
                    Text("Start")
                }
            } else { // When exercising
                
                VStack {
                    if self.timerManager.timerMode == .squeez {
                        Text("Go!")
                            .font(.system(size: 20))
                        Text(String(timerManager.exerciseSeconds))
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

                    Button(action: {
                        self.timerManager.reset()
                    }, label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                    })
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading)
                
            }
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
