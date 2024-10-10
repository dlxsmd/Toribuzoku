//
//  GameManageView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI

struct GameManageView: View {
    @ObservedObject var gameData: GameData // GameViewControllerを観察
    
    var body: some View {
        VStack {
            Spacer()
            Text("Score: \(gameData.score)") // スコアを表示
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .padding()
        }
    }
}

#Preview {
    GameManageView(gameData: GameData())
}
