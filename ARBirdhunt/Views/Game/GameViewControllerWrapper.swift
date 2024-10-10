//
//  GameViewControllerWrapper.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/05.
//

import SwiftUI

class GameData: ObservableObject {
    @Published var gameBegan: Bool = false
    @Published var gameOver: Bool = false
    @Published var score: Int = 0
    @Published var isHighScore: Bool = false
    @Published var timeRemaining: Int = 60
}

struct GameViewControllerWrapper: UIViewControllerRepresentable {
    @ObservedObject var gameData: GameData // GameViewControllerを観察
    let gameViewController: GameViewController
    
    class Coordinator: NSObject,GameViewControllerDelegate {
        var parent: GameViewControllerWrapper
        var gameData: GameData

        init(_ parent: GameViewControllerWrapper, gamedata: GameData) {
            self.parent = parent
            self.gameData = gamedata
        }
        
        var gameBegan: Bool = false {
            didSet {
                gameData.gameBegan = gameBegan
            }
        }
        
        var gameOver: Bool = false {
            didSet {
                gameData.gameOver = gameOver
            }
        }
        
        var score: Int = 0 {
            didSet {
                gameData.score = score
            }
        }
        
        var isHighScore: Bool = false {
            didSet {
                gameData.isHighScore = isHighScore
            }
        }
        
        var timeRemaining: Int = 60 {
            didSet {
                gameData.timeRemaining = timeRemaining
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, gamedata: gameData)
    }
    
    func makeUIViewController(context: Context) -> GameViewController {
        gameViewController.delegate = context.coordinator
        return gameViewController // 既存のインスタンスを返す
    }

    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        // ビューコントローラーを更新する際の処理
    }
}

protocol GameViewControllerDelegate {
    var gameBegan: Bool { get set }
    var gameOver: Bool { get set }
    var score: Int { get set }
    var isHighScore: Bool { get set }
    var timeRemaining: Int { get set }
}
