//
//  ResultView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI

struct ResultView: View {
    //MARK: Private Property
    @State private var isTrophy = true
    @State private var isshowCelebrate = false
    @State private var isTitle = false
    @State private var isRetry = false
    @State private var isLoading = true
    @ObservedObject var gameData: GameData //GameViewControllerを観察

    @StateObject private var vm = Networking.shared

    var body: some View {
            ZStack{
                if isshowCelebrate{
//                    Color.black.opacity(0.25)
                }
                VStack{
                    Text("Result".localized())
                        .font(.custom("Kaisei Opti", size: 50))
                        .fontWeight(.semibold)
                    VStack{
                        Text("あなたのスコア: \(gameData.score)")
                            .font(.custom("Kaisei Opti", size: 20))
                        Text("390pt x \(gameData.normalBirdCount) = \(390 * gameData.normalBirdCount)pt")
                            .font(.custom("Kaisei Opti", size: 20))
                        Text("3900pt x \(gameData.specialBirdCount) = \(3900 * gameData.specialBirdCount)pt")
                            .font(.custom("Kaisei Opti", size: 20))
                        Text("計　\(gameData.score)pt")
                            .font(.custom("Kaisei Opti", size: 20))
                            .underline()
                        Text("\(DateFormatter.normal(from: Date()))")
                            .font(.caption2)
                    }
                    Text("今日のベストスコア: \(vm.todayhighScores.first?.score ?? 0)")
                        .font(.custom("Kaisei Opti", size: 20))
                    Text("今までのベストスコア: \(vm.highScores.first?.score ?? 0)")
                        .font(.custom("Kaisei Opti", size: 20))
                    
                    Button(vm.isSubmitting ? "送信中" : "リトライ"){
                        vm.userScore = 0
                        isRetry.toggle()
                    }.disabled(vm.isSubmitting)
                    Button(vm.isSubmitting ? "送信中" : "終了する"){
                        vm.userName = ""
                        vm.userScore = 0
                        isTitle.toggle()
                    }.disabled(vm.isSubmitting)
                }
                if gameData.isHighScore{ //default: gameData.isHighScore
                    HighScoreUpdateView(gameData: gameData)
                }
                if isLoading{
                    LoadingScreenView()
                }
            }
            
            .onAppear() {
                DispatchQueue.global(qos: .userInitiated).async {
                    let dispatchGroup = DispatchGroup()

                    dispatchGroup.enter()
                    DispatchQueue.main.async {
                        vm.userScore = gameData.score
                        vm.registerToScoreboard()
                        vm.fetchHighScores()
                        vm.fetchTodayTopScore()
                        gameData.isHighScore = vm.checkSuperior()
                        dispatchGroup.leave()
                    }
                    
                    // Notify when all tasks are completed
                    dispatchGroup.notify(queue: .main) {
                        // After all operations are done, wait for 3 seconds before setting isLoading to false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self.isLoading = false
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isTitle){
            TitleView()
        }
        .fullScreenCover(isPresented: $isRetry){
            GameView()
        }
    }
    
}


#Preview{
    ResultView(gameData: GameData())
}
