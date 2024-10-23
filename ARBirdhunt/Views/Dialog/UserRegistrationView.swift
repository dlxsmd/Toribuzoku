//
//  UserRegistrationView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI

struct UserRegistrationView: View {
    //シングルトンインスタンスを使用
    @StateObject private var vm = Networking.shared
    @EnvironmentObject var soundManager: SoundManager
    
    @State private var isStartGame = false
    @Binding var isStart:Bool
    var body: some View {
        ZStack{
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ZStack(alignment:.topTrailing){
                VStack{
                    Text("Enter the name".localized())
                        .font(.custom("Kaisei Opti", size: 25))
                        .padding(.bottom,50)
                    
                    VStack{
                        TextField("焼き鳥　戦士", text: $vm.userName)
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                        
                        Divider()
                            .frame(width: 250)
                        Text("※Please do not use names that can identify individuals, as their scores and names will be published in the rankings.".localized())
                            .font(.custom("Kaisei Opti", size: 10))
                            .frame(width: 250)
                    }
                    
                    
                    Button(action: {
                        isStartGame.toggle()
                        DispatchQueue.main.async {
//                            soundManager.playSE(fileName: "start")
//                            soundManager.stopBGM()
                            
                        }
                    }) {
                        Text("Start".localized())
                            .font(.custom("Kaisei Opti", size: 15))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 250)
                            .background(Color(red: 253/255, green: 88/255, blue: 69/255))
                            .cornerRadius(40)
                        
                    }.disabled(vm.userName.isEmpty)
                        .padding(.top,10)
                    
                }
                .padding(50)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .cornerRadius(100)
                
                Button(action: {
                    soundManager.playSE(fileName: "tap")
                    isStart.toggle()
                }) {
                    Image("CancelButton")
                }
                
            }.frame(width:UIScreen.main.bounds.width-40)
                .fullScreenCover(isPresented: $isStartGame) {
                    GameView()
                }
        }
    }
}

#Preview {
    UserRegistrationView(isStart: .constant(true))
}
