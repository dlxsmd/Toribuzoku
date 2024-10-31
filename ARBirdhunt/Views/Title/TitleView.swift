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
                    VStack(spacing:0){
                        HStack{
                            Button(action: {
                                soundManager.playSE(fileName: "tap")
                                withAnimation{
                                    isSetting.toggle()
                                }
                            }) {
                                Image("SettingButton")
                                    .padding(.horizontal,30)
                                    .padding(.top,UIScreen.main.bounds.height * 0.10)
                                
                            }
                            Spacer()
                        }
                        Text("鳥武族")
                            .foregroundColor(.white)
                            .font(.custom("Kaisei Opti", size: 50))
                    }
                    
                    HStack{
                        Text("〜")
                        Text("Burakumin".localized())
                        Text("〜")
                    }.font(.custom("Kaisei Opti", size: 25))
                        .foregroundColor(.white)
                    
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
                        
                        commonButtonView(text: "Play".localized(),image: "common_button_rightgreen") {
                                soundManager.playSE(fileName: "tap")
                                withAnimation{
                                    isStart.toggle()
                                }
                            }
                        
                        commonButtonView(text: "How to play".localized(),image: "common_button_blue") {
                            soundManager.playSE(fileName: "tap")
                            withAnimation{
                                isHowTo.toggle()
                            }
                        }
                        
                        commonButtonView(text: "Ranking".localized(),image: "common_button_purple") {
                            soundManager.playSE(fileName: "tap")
                            withAnimation{
                                isRanking.toggle()
                            }
                        }

                        
                    }
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
