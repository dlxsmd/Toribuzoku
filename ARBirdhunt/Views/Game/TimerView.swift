//
//  TimerView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//
import SwiftUI

struct TimerView: View {
    @ObservedObject var gameData: GameData // GameViewControllerを観察

    @State var timerSeconds = 20
    
    let customInterval : Int = 60
    
    var body: some View {
        
        ZStack{
            
            Circle()
                .fill(Color.white)
            
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.08)
                .foregroundColor(.black)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(gameData.timeRemaining) / CGFloat(customInterval))
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270.0))
                .foregroundColor(getCircleColor(timerSeconds: gameData.timeRemaining))
                .animation(.linear)
            
            Text(String(gameData.timeRemaining))
                .font(.system(size: 25))
                .bold()
            
        }
    }
    private func getCircleColor(timerSeconds: Int) -> Color {
        
        if (timerSeconds <= 10 && timerSeconds > 3) {
            return Color.yellow
        } else if (timerSeconds <= 3){
            return Color.red
        } else {
            return Color.green
        }
    }
}



#Preview{
    TimerView(gameData: GameData())
}

