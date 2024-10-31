//
//  GameViewController+SwipeGesture.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/05.
//

import SwiftUI
import ARKit

//MARK: - SwipeGesture
extension GameViewController: ARSessionDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: skView.scene!)
        swipeParticle.position = location
        swipeParticle.particleBirthRate = 400
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let locationSKView = touch.location(in: skView.scene!)
        swipeParticle.position = locationSKView
            
        // スワイプ中の位置でヒットテストを実行
        let swipeLocation = touch.location(in: arView)
        
        let hitTestResults = arView.hitTest(swipeLocation, options: [
            SCNHitTestOption.boundingBoxOnly: true,
            SCNHitTestOption.ignoreHiddenNodes: false
        ])
        
        if let result = hitTestResults.first {
            let node = result.node
            print("スワイプ中にヒットしたノード: \(node.name ?? "unknown")")
                
            if let birdNode = birdNodes.first(where: { birdNode in
                birdNode.name == node.name ||
                birdNode == node ||
                birdNode.childNode(withName: node.name ?? "", recursively: true) != nil
            }) {
                if !hitBirds.contains(birdNode) {
                    playSwipeSFX()
                    hitBirds.insert(birdNode, at: 0)
                    removeBird(birdNode)
                    
                    
                    if birdNode.name == "normalBird" {
                        delegate.normalBirdCount += 1
                        delegate.score += Int(390.0 * delegate.comboMultiplier)
                    } else if birdNode.name == "specialBird" {
                        delegate.specialBirdCount += 1
                        delegate.score += Int(3900.0 * delegate.comboMultiplier)
                    }else if birdNode.name == "timerBird" {
                        delegate.timeRemaining += 5
                    }
                    
                    delegate.currentCombo += 1
                    updateComboMultiplier()
                    resetComboTimer()
                    
                    print("スワイプ中に倒した! スコア: \(delegate.score)")
                    addBird()
                    startBirdTimer()
                    
                    print("新しい鳥を追加しました")
        
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeParticle.particleBirthRate = 0
    }

    func playSwipeSFX() {
        sliceSFX.stop()
        sliceSFX.currentTime = 0.0
        sliceSFX.play()
    }
    
    func updateComboMultiplier() {
        // コンボ数に応じて倍率を増加
        delegate.comboMultiplier = min(1.0 + Double(delegate.currentCombo) * 0.1, 3.0) // 最大3倍まで
    }
    
    func resetComboTimer() {
        comboTimer?.invalidate()
        comboTimer = Timer.scheduledTimer(withTimeInterval: comboTimelimit, repeats: false, block: { [weak self] _ in
            self?.resetCombo()
        })
    }
    
    func resetCombo(){
        delegate.currentCombo = 0
        delegate.comboMultiplier = 1.0
    }
}
