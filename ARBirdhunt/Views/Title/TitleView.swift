//
//  TitleView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI

struct TitleView: View {
    @EnvironmentObject var soundManager: SoundManager
    @State var isStart = false
    @State var isSetting = false
    @State var isRanking = false
    @State var isHowTo = false
    
    @State var charOffset = -10
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("TitleBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                GeometryReader{ geometry in
                    ParticleView(size: geometry.size)
                }
                VStack{
                    HStack{
                        Button(action: {
                            soundManager.playSE(fileName: "tap")
                            withAnimation{
                                isSetting.toggle()
                            }
                        }) {
                            Image("SettingButton")
                                .padding(30)
                        }
                        Spacer()
                    }
                    Text("鳥武族")
                        .foregroundColor(.white)
                        .font(.custom("Kaisei Opti", size: 50))
                    Spacer()
                    HStack{
                        Spacer()
                        Image("TitleCharacter")
                            .offset(y:CGFloat(charOffset))
                            .onAppear(){
                                withAnimation(Animation.easeInOut(duration: 1).repeatForever()){
                                    charOffset = -20
                                }
                            }
                    }
                }
                
                HStack{
                    VStack{
                        
                        Button {
                            soundManager.playSE(fileName: "tap")
                            withAnimation{
                                isStart.toggle()
                            }
                        } label: {
                            ButtonStyleView(text: "Play".localized(), color: Color(red: 96/255, green: 184/255, blue: 74/255))

                        }

                        Button(action: {
                            soundManager.playSE(fileName: "tap")
                            // explain the game
                            withAnimation{
                                isHowTo.toggle()
                            }
                        }) {
                            ButtonStyleView(text: "How to play".localized(), color: Color(red: 99/255, green: 171/255, blue: 164/255))
                        }

                        Button {
                            withAnimation{
                                isRanking.toggle()
                            }
                        } label: {
                            ButtonStyleView(text: "Ranking".localized(), color: Color(red: 138/255, green: 130/255, blue: 220/255))
                        }
                    }.padding(.leading,15)
                    Spacer()
                }
                if isSetting{
                    LanguageSettingView(isSetting: $isSetting)
                }
                if isStart{
                    UserRegistrationView(isStart: $isStart)
                }
                if isHowTo{
                    HowToView(isHowTo: $isHowTo)
                }
                if isRanking{
                    TopRankingView(isRanking: $isRanking)
                }
            }
        }
        .onAppear(){
            soundManager.playBGM(fileName: "TitleBackground")
        }
        .onDisappear(){
            soundManager.stopBGM()
        }
    }
}

#Preview {
    TitleView()
        .environmentObject(SoundManager.shared)
}
