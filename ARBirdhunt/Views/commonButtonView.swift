//
//  ButtonStyleView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/02.
//

import SwiftUI

struct commonButtonView: View {
    let text: String
    let image: String
    let ontap: () -> Void
    
    var body: some View {
        VStack{
            Text(text)
                .foregroundColor(.white)
                .font(.custom("Kaisei Opti", size: 20))
                .background(
                    Image(image)
                )
                .padding(.vertical,10)
        }.frame(width: 190)
            .onTapGesture {
                ontap()
            }
            .padding()
        
    }
}

#Preview {
    commonButtonView(text: "Start", image: "common_button_rightgreen") {
        print("Start")
    }
}
