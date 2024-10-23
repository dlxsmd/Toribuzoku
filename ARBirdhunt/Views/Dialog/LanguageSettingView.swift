//
//  LanguageSettingView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/03.
//

import SwiftUI

struct LanguageSettingView: View {
    @EnvironmentObject var localizableManager: LocalizableManager
    @EnvironmentObject var soundManager: SoundManager
    @Binding var isSetting: Bool
    var body: some View {
        ZStack{
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ZStack(alignment:.topTrailing){
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())],spacing:20){
                    ForEach(LanguageTypes.allCases, id: \.self) { language in
                        Button(action: {
                            DispatchQueue.main.async {
                                localizableManager.currentLanguage = language
                                soundManager.playSE(fileName: "tap")
                                isSetting.toggle()
                            }
                        }, label: {
                            HStack{
                                Image(language.image)
                                Text(language.name)
                                    .foregroundColor(.black)
                            }
                        })
                    }
                }
                .padding(50)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .cornerRadius(80)
                
                Button(action: {
                    soundManager.playSE(fileName: "tap")
                    isSetting.toggle()
                }) {
                    Image("CancelButton")
                }
                
            }.frame(width:UIScreen.main.bounds.width-40)
        }
    }
}

#Preview {
    LanguageSettingView(isSetting: .constant(true))
        .environmentObject(LocalizableManager.shared)
}
