//
//  ScoreboardView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/16.
//

import SwiftUI

struct RankingView: View {
    @ObservedObject var networking = Networking.shared
    var body: some View {
        VStack{
            List(networking.allScores){ score in
                HStack{
                    Text(score.name)
                    Spacer()
                    Text("\(score.score)")
                }
            }
        }
        .onAppear(){
            networking.fetchAllScores()
        }
    }
}

#Preview {
    RankingView()
}
