//
//  Networking.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/16.
//

import Foundation
import Alamofire



class Networking: ObservableObject {
    static let shared = Networking()
    
    @Published var highScores: [FetchUserDataModel] = []
    @Published var allScores: [FetchUserDataModel] = []
    @Published var todayhighScores: [FetchUserDataModel] = []
    
    @Published var isSubmitting: Bool = false
    @Published var userName: String = ""
    @Published var userScore: Int = 0
    @Published var userEmail: String = ""
    
    
    
    func fetchHighScores() {
        let url = "https://rankingapp-production.up.railway.app/players/top"
        
        if !development{
            AF.request(url).responseDecodable(of: [FetchUserDataModel].self) { response in
                switch response.result {
                case .success(let highScores):
                    DispatchQueue.main.async {
                        self.highScores = highScores
                    }
                case .failure(let error):
                    print("Error fetching high scores: \(error)")
                }
            }
        }else{
            DispatchQueue.main.async {
                self.highScores = DummyHighScoreData
            }
        }
    }
    
    func fetchTodayTopScore() {
        let url = "https://rankingapp-production.up.railway.app/players/today"
        
        if !development{
            AF.request(url).responseDecodable(of: [FetchUserDataModel].self) { response in
                switch response.result {
                case .success(let todayhighScores):
                    DispatchQueue.main.async {
                        self.todayhighScores = todayhighScores
                        print("todayhighScores")
                    }
                case .failure(let error):
                    print("Error fetching high scores: \(error)")
                }
            }
        }else{
            print("development mode")
        }
    }
    
    func fetchAllScores() {
        let url = "https://rankingapp-production.up.railway.app/players/all"
        
        if !development{
            AF.request(url).responseDecodable(of: [FetchUserDataModel].self) { response in
                switch response.result {
                case .success(let allScores):
                    DispatchQueue.main.async {
                        self.allScores = allScores
                    }
                case .failure(let error):
                    print("Error fetching all scores: \(error)")
                }
            }
        }else{
            DispatchQueue.main.async {
                self.allScores = DummyAllScoreData
            }
        }
    }
    
    func registerToScoreboard() {
        // ユーザーデータのバリデーション
        guard !userName.isEmpty, userScore >= 0 else {
                print("Invalid user data")
                return
            }
        
        let url = "https://rankingapp-production.up.railway.app/players"
        
        // スコア送信中フラグを立てる
        isSubmitting = true
        let user = RegisterUserDataModel(name: userName, score: userScore, createdAt: Date().ISO8601Format(), email: userEmail)
        // Alamofireを使ってPOSTリクエストを送信
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).response { response in
            DispatchQueue.main.async {
                self.isSubmitting = false // 送信完了
                
                // レスポンスの処理
                switch response.result {
                case .success:
                    if let httpResponse = response.response, httpResponse.statusCode == 200 {
                        print("スコア送信成功!")
                    } else {
                        print("スコア送信失敗: \(String(describing: response.response?.statusCode))")
                    }
                case .failure(let error):
                    print("エラー: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func checkSuperior() -> Bool{
        if highScores.isEmpty {
            return true
        }
        return highScores.prefix(3).contains { userScore > $0.score }
    }
}
