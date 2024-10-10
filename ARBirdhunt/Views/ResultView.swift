//
//  ResultView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI

struct ResultView: View {
    @State var isTrophy = true //仮プロパティ
    @State var isshowCelebrate = false
    @ObservedObject var gameData: GameData //GameViewControllerを観察

    @StateObject private var userManagerModel = UserManagerModel.shared

    var body: some View {
        ZStack{
            ZStack{
                if isshowCelebrate{
                    Color.black.opacity(0.25)
                }
                VStack{
                    Text("Result".localized())
                    VStack(alignment:.trailing){
                        Text("スコア: \(gameData.score)")
                            .font(.title)
                            .padding()
                        Text("2024/09/25")
                            .font(.caption2)
                    }
                    Text("ベストスコア: 100")
                        .font(.title3)
                                        
                    Button(userManagerModel.isSubmitting ? "送信中" : "終了する"){
                        //タイトル画面へ
                    }
                }
            }
            if !gameData.isHighScore{ //default: gameData.isHighScore
                HighScoreUpdateView(gameData: gameData)
            }
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if isTrophy{
                    isshowCelebrate.toggle()
                }
            }
            userManagerModel.updateUserScore(gameData.score)
            //ベストスコアの取得と保存
        }
    }
    
}

#Preview{
    ResultView(gameData: GameData())
}
