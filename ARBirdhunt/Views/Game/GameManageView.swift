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
