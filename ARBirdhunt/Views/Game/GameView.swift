//
//  GameView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI

struct GameView: View {
    @StateObject private var gameData = GameData() // Create an instance of GameViewController
    @State private var gameViewController: GameViewController?
    @EnvironmentObject var soundManager: SoundManager
    
    @State private var isLoading = true


    var body: some View {
        ZStack {
            ZStack{
                if let gameVC = gameViewController{
                    GameViewControllerWrapper(gameData: gameData,gameViewController: gameVC)
                        .edgesIgnoringSafeArea(.all)

                    GameManageView(gameData: gameData)
                    VStack {
                        HStack {
                            TimerView(gameData: gameData)
                                .frame(width: 80, height: 80)
                                .padding()
                        }
                        Spacer()
                    }
                }
                if isLoading {
                    LoadingScreenView()
                }
                
                
            }.onAppear(){
                DispatchQueue.global(qos: .userInitiated).async {
                    let newGameVC = GameViewController()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                        self.gameViewController = newGameVC
                        self.isLoading = false
                    }
                }
                soundManager.playBGM(fileName: "GameBGM")
            }
        }
        .fullScreenCover(isPresented: $gameData.gameOver){
            ResultView(gameData: gameData)
        }
    }
}

#Preview {
    GameView()
}
