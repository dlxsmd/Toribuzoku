//
//  HighScoreUpdateView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/07.
//

import SwiftUI

struct HighScoreUpdateView: View {
    @EnvironmentObject var localizableManager: LocalizableManager
    @EnvironmentObject var soundManager: SoundManager

    @ObservedObject var gameData: GameData //GameViewControllerを観察
    @StateObject private var userManagerModel = UserManagerModel.shared
    
    @State var Email: String = ""
    
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ZStack(alignment:.topTrailing){
                VStack{
                    Text("メールアドレスを入力してね".localized())
                        .font(.custom("Kaisei Opti", size: 18))
                        .padding(.bottom,50)
                    
                    VStack{
                        TextField("yakitori@jec.ac.jp", text: $Email)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                            .frame(width: 250)
                        Text("※Please do not use names that can identify individuals, as their scores and names will be published in the rankings.".localized())
                            .font(.custom("Kaisei Opti", size: 10))
                            .frame(width: 250)
                    }
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            userManagerModel.updateUserName(Email)
                            soundManager.playSE(fileName: "start")
                            soundManager.stopBGM()
                            gameData.isHighScore.toggle()
                        }
                    }) {
                        Text("Send".localized())
                            .font(.custom("Kaisei Opti", size: 15))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 250)
                            .background(Color(red: 253/255, green: 88/255, blue: 69/255))
                            .cornerRadius(40)
                        
                    }.disabled(Email.isEmpty)
                        .padding(.top,10)
                    
                }
                .padding(50)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .cornerRadius(80)
                
                Button(action: {
                    soundManager.playSE(fileName: "tap")
                    gameData.isHighScore.toggle()
                }) {
                    Image("CancelButton")
                }
                
            }.frame(width:UIScreen.main.bounds.width-40)
        }
    }
}

#Preview {
    HighScoreUpdateView(gameData: GameData())
}
