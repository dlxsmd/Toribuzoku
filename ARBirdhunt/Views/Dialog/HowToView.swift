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
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ZStack(alignment:.topTrailing){
                TabView{
                    ForEach(ruleString.keys.sorted(), id: \.self){ key in
                        VStack{
                            Text(key)
                                .font(.custom("Kaisei Opti", size: 20))
                                .padding(.bottom, 30)
                            Text(ruleString[key]!)
                                .font(.custom("Kaisei Opti", size: 15))
                                .multilineTextAlignment(.center)
                        }
                    }
                }.tabViewStyle(PageTabViewStyle())
                .padding(30)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .cornerRadius(80)
                .frame(height: 300)
                
                Button(action: {
                    isHowTo.toggle()
                }) {
                    Image("CancelButton")
                }
                
            }.frame(width:UIScreen.main.bounds.width-40)
        }
    }
}


let ruleString = [
    "1：戦いの舞台": "この戦場は、現実と幻が交錯する場所。勇者たちよ、スマートフォンを手に取り、ARの世界へ足を踏み入れよ。",
                  "2：敵の姿":"空を舞う鳥たちは、我が敵なり。彼らは様々な種類を持ち、それぞれ異なる特性を有す。高得点を狙う者は、王冠を被る鳥を見逃してはならぬ。",
                  "3：勝利への道": "スワイプすることで、敵を討ち取ることができる。連続して倒すことでコンボが発生し、得点は倍増する。名誉ある戦士となるため、連続攻撃を目指せ！",
                  "4：時の流れ": "戦いには限りがある。時間延長の特性を持つ鳥を撃ち落とし、戦い続けることが勝利への鍵となる。果敢に挑む者には、運命が微笑むであろう。",
                  "5：名声と栄光": "高得点を叩き出し、リーダーボードに名を刻め。仲間たちと競い合い、真の勇者となるために、己の力を試せ！",
]


#Preview {
    HowToView(isHowTo: .constant(true))
}
