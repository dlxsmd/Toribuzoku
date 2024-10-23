//
//  LoadingScreenView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/09.
//

import SwiftUI

let loadingAssets = [
    "loading_swift",
    "loading_meet",
    "loading_yakitori"
]

let tipsMessages = [
    "Try to catch the bird in the center of the screen",
    "The more birds you catch, the higher your score will be",
    "The game is over when the time runs out"
]

struct LoadingScreenView: View {
    @State private var currentImageIndex = 0
    @State private var currentTipsIndex = Int.random(in: 0..<tipsMessages.count)
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Tips...")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Text(tipsMessages[currentTipsIndex])
                    .foregroundColor(.white)
                    .frame(height: 50)

                
                HStack {
                    ForEach(0..<loadingAssets.count) { index in
                        if currentImageIndex == index {
                            Image(loadingAssets[index])
                        } else {
                            Circle()
                                .fill(Color.white)
                                .padding(15)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            currentTipsIndex = (currentTipsIndex + 1) % tipsMessages.count
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        stopTimer() // 既存のタイマーがあれば停止
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentImageIndex = (currentImageIndex + 1) % loadingAssets.count
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    LoadingScreenView()
}
