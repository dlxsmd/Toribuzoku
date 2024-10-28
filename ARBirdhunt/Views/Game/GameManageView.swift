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
            Text("Combo: \(gameData.currentCombo) (x\(String(format: "%.1f", gameData.comboMultiplier)))")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .font(.system(size: 30))
                .font(.custom("Kaisei Opti", size: 30))
            HStack{
                HStack{
                    Image("normalChicken")
                    Text("x \(gameData.normalBirdCount)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                }
                Spacer()
                HStack{
                    Image("specialChicken")
                    Text("x \(gameData.specialBirdCount)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                }
            }.padding()
        }
    }
}

#Preview {
    GameManageView(gameData: GameData())
}
