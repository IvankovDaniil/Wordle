//
//  TimerView.swift
//  Wordle
//
//  Created by Даниил Иваньков on 07.02.2025.
//
import SwiftUI

struct TimerView: View {
    @State private var stopwatchSec: Int = 0
    @State private var stopwatchMin: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        HStack(spacing: 0) {
            if stopwatchMin == 0 {
                Text("\(stopwatchSec)\"")
            } else {
                Text("\(stopwatchMin)'\(stopwatchSec)\"")
            }
        }
        .onReceive(timer) { _ in
            stopwatchSec += 1
            
            if stopwatchSec == 60 {
                stopwatchMin += 1
                stopwatchSec = 0
            }
        }
        .font(Font.custom("Chalkboard SE", size: 20))
    }
}
