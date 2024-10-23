//
//  HowToView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/18.
//

import SwiftUI

struct HowToView: View {
    @Binding var isHowTo: Bool
    var body: some View {
        ZStack{
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("How to Play")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                Text("1. Find a flat surface and place the bird on it.")
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                Text("2. Tap the bird to start the game.")
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                Text("3. Move your phone to aim at the bird.")
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                Text("4. Tap the screen to shoot the bird.")
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                Button(action: {
                    isHowTo.toggle()
                }, label: {
                    Text("Close")
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(100)
                })
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    HowToView(isHowTo: .constant(true))
}
