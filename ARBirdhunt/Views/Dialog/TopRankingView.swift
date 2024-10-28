//
//  TopRankingView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/18.
//

import SwiftUI

struct TopRankingView: View {
    @StateObject private var vm = Networking.shared
    @Binding var isRanking:Bool
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            ZStack(alignment:.topTrailing){
                VStack{
                    Text("Ranking".localized())
                        .font(.custom("Kaisei Opti", size: 25))
                        .padding(.bottom,15)
                    
                    VStack{
                        ScrollView{
                            ForEach(Array(vm.highScores.enumerated()), id: \.element.id) { index, highScore in
                                HStack {
                                    Text("\(index + 1)位")
                                        .font(.custom("Kaisei Opti", size: 25))
                                    Spacer()
                                    Text(highScore.name)
                                        .font(.custom("Kaisei Opti", size: 20))
                                        .lineLimit(1)
                                    Spacer()
                                    Text("\(highScore.score)pt")
                                        .font(.custom("Kaisei Opti", size: 20))
                                }.padding(5)
                            }
                        }.frame(height:145)
                        Text("：")
                            .font(.custom("Kaisei Opti", size: 25))
                        NavigationLink(destination: RankingView()){
                            Text("全体の順位を見る")
                                .font(.custom("Kaisei Opti", size: 25))
                                .foregroundColor(.white)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 12)
                                .background(Color(red: 198/255, green: 92/255, blue: 100/255))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal,20)
                    .frame(width:UIScreen.main.bounds.width-40)
                }
                .padding(.vertical,40)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .cornerRadius(100)
                
                Button(action: {
                    isRanking.toggle()
                }) {
                    Image("CancelButton")
                }
                
            }.frame(width:UIScreen.main.bounds.width-40)
        }
        .onAppear(){
            vm.fetchHighScores()
        }
    }
}

#Preview {
    TopRankingView(isRanking: .constant(true))
}
