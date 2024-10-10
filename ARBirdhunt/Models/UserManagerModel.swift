//
//  UserManagerModel.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/09/25.
//

import SwiftUI
import Alamofire

struct RegistrationUserDataModel: Codable{
    var name:String
    var score:Int
}

class UserManagerModel: ObservableObject {
    // シングルトンインスタンス生成
    static let shared = UserManagerModel()
    
    // ユーザーデータの送信状態
    @Published var isSubmitting: Bool = false
    
    private var userName: String = ""
    private var userScore: Int = 0
    
    // ユーザー名を更新するメソッド
    func updateUserName(_ newName: String) {
        userName = newName
    }
    
    // スコアを更新するメソッド
    func updateUserScore(_ newScore: Int) {
        userScore = newScore
        DispatchQueue.main.async {
            self.registerToScoreboard() // スコア更新後にサーバー送信
        }
    }
    
    // サーバーにスコアを送信するメソッド
    func registerToScoreboard() {
        // ユーザーデータのバリデーション
        guard !userName.isEmpty, userScore >= 0 else {
                print("Invalid user data")
                return
            }
        
        let url = "https://rankingapp-28tr.onrender.com/players"
        
        // スコア送信中フラグを立てる
        isSubmitting = true
        let user = RegistrationUserDataModel(name: userName, score: userScore)
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
}
