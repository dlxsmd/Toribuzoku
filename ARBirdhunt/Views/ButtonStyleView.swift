//
//  ButtonStyleView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/02.
//

import SwiftUI

struct ButtonStyleView: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack{
            Image("MenuPointer")
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 20))
            
        }
        .frame(width: 200, height: 60)
        .padding(.vertical,10)
        .background(color)
        .cornerRadius(100)
        
    }
}

#Preview {
    ButtonStyleView(text: "Start", color: .blue)
}
