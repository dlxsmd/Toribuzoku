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
                            Text("\(key)".localized())
                                .font(.custom("Kaisei Opti", size: 20))
                                .padding(.bottom, 30)
                            Text("\(ruleString[key]!)".localized())
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
    "1: Stage of battle": "This battlefield is a place where reality and illusion intersect. Brave men and women, pick up your smartphones and step into the world of AR.",
    "2: The enemy": "The birds of the air are my enemies. They come in many varieties, each with different characteristics. Those who aim for a high score should not miss the bird that wears the crown.",
    "3: Path to Victory": "By swiping, you can take out enemies. Defeat them consecutively to generate combos and double your score. Aim for consecutive attacks to become an honorable warrior!",
    "4: The passage of time": "The battle is limited. The key to victory is to shoot down the birds with time-extending properties and keep fighting. Fate will smile on those who boldly take up the challenge.",
    "5: Fame and Glory": "Beat the high scores and etch your name on the leaderboard. Compete with your friends and test your strength to become a true hero!",
]


#Preview {
    HowToView(isHowTo: .constant(true))
}
