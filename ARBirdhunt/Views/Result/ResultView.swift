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
    
    @State private var TodayHighScoreUserName: String = ""
    @State private var TodayHighScore: Int = 0
    
    @ObservedObject var gameData: GameData //GameViewControllerを観察

    @StateObject private var vm = Networking.shared

    var body: some View {
            ZStack{
                if gameData.isHighScore{
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                }
                VStack{
                    Text("Result".localized())
                        .font(.custom("Kaisei Opti", size: 50))
                        .fontWeight(.semibold)
                    
                    VStack(spacing:0){
                        Label("Your Score".localized(), image: "decorationYakitori")

                        
                        HStack{
                            Image("normalYakitori")
                            Text("390pt x \(gameData.normalBirdCount) = \(390 * gameData.normalBirdCount)pt")
                        }
                        
                        HStack{
                            Image("specialYakitori")
                            Text("3900pt x \(gameData.specialBirdCount) = \(3900 * gameData.specialBirdCount)pt")
                        }
                        
                        Text("ComboBonus".localized())
                        +
                        Text(":\(gameData.score - (390 * gameData.normalBirdCount + 3900 * gameData.specialBirdCount))pt")
                        
                        Text("計　\(gameData.score)pt")
                            .underline()
                        
                        Text("\(DateFormatter.normal(from: Date()))")
                            .font(.caption2)
                        
                    }.font(.custom("Kaisei Opti", size: 20))
                        .padding(.vertical,5)
                    
                    VStack(spacing: 0){
                        Label("Best Score of the Day".localized(), image: "decorationYakitori")
                            .font(.custom("Kaisei Opti", size: 20))
                        HStack{
                            Text("\(TodayHighScoreUserName)")
                                .font(.custom("Kaisei Opti", size: 20))
                            +
                            Text("さん ")
                                .font(.custom("Kaisei Opti", size: 12))
                            
                            Text("\(TodayHighScore)pt")
                                .font(.custom("Kaisei Opti", size: 20))
                        }
                    }
                    
                    VStack(spacing:0){
                        Label("Best score to date".localized(), image: "decorationYakitori")
                            .font(.custom("Kaisei Opti", size: 20))
                        HStack{
                            Text("\(vm.highScores.first?.name ?? "")")
                                .font(.custom("Kaisei Opti", size: 20))
                            +
                            Text("さん ")
                                .font(.custom("Kaisei Opti", size: 12))

                            Text("\(vm.highScores.first?.score ?? 0)pt")
                                .font(.custom("Kaisei Opti", size: 20))
                        }
                    }
                    
                    commonButtonView(text: "Retry".localized(), image: "common_button_brown") {
                        vm.userScore = 0
                        isRetry.toggle()
                    }.disabled(vm.isSubmitting)
                    
                    commonButtonView(text: "Back to Title".localized(), image: "common_button_red") {
                        vm.userEmail = ""
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
                        gameData.isHighScore = vm.checkSuperior()
                        if !gameData.isHighScore{
                            vm.registerToScoreboard()
                        }
                        if vm.todayhighScores.first?.score ?? 0 > gameData.score{
                            TodayHighScoreUserName = vm.todayhighScores.first!.name
                            TodayHighScore = vm.todayhighScores.first!.score
                        }else{
                            TodayHighScoreUserName = vm.userName
                            TodayHighScore = gameData.score
                        }
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
