//
//  SoundManager.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/04.
//

import AVFoundation

class SoundManager: ObservableObject {
    static let shared = SoundManager()

    private var sePlayer: AVAudioPlayer?
    private var bgmPlayer: AVAudioPlayer?
    
    // 効果音(SE)を再生するメソッド
    func playSE(fileName: String) {
        guard let url = Bundle.main.url(forResource: "\(fileName)", withExtension: "mp3") else { return }
        do {
            sePlayer = try AVAudioPlayer(contentsOf: url)
            sePlayer?.play()
        } catch {
            print("SEの再生に失敗しました: \(error)")
        }
    }
    
    // BGMを再生するメソッド
    func playBGM(fileName: String, loops: Int = -1) {
        guard let url = Bundle.main.url(forResource: "\(fileName)", withExtension: "mp3") else { return }
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = loops  // -1は無限ループ
            bgmPlayer?.play()
        } catch {
            print("BGMの再生に失敗しました: \(error)")
        }
    }
    
    // BGMを停止するメソッド
    func stopBGM() {
        bgmPlayer?.stop()
    }

    // SEを停止するメソッド
    func stopSE() {
        sePlayer?.stop()
    }
}
