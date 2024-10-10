//
//  GameViewController+SwipeGesture.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/05.
//

import SwiftUI
import ARKit

extension GameViewController: ARSessionDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: skView.scene!)
        swipeParticle.position = location
        swipeParticle.particleBirthRate = 300
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let locationSKView = touch.location(in: skView.scene!)
        swipeParticle.position = locationSKView
        
        playSwipeSFX()
        
        // スワイプ中の位置でヒットテストを実行
        let swipeLocation = touch.location(in: arView)
        
        let hitTestResults = arView.hitTest(swipeLocation, options: [
            SCNHitTestOption.boundingBoxOnly: true,
            SCNHitTestOption.ignoreHiddenNodes: false
        ])
        /*
        if let result = hitTestResults.first {
            let node = result.node
            print("スワイプ中にヒットしたノード: \(node.name ?? "unknown")")
            
            if node.name?.contains("Object") == true || node.name?.contains("Mesh") == true {
                if let birdNode = birdNodes.first(where: { $0 == node || $0.childNodes.contains(node) }) {
                    if !hitBirds.contains(birdNode) {
        
                        hitBirds.append(birdNode)
                        
                        if node.name?.contains("Object") == true {
                            delegate.score += 390
                        } else if node.name?.contains("Mesh") == true {
                            delegate.score += 3900
                        }
                        
                        print("スワイプ中に倒した! スコア: \(delegate.score)")
                        
                        removeBird(birdNode)
                        print("鳥を削除しました: \(birdNode.name ?? "unknown")")
                        addBird()
                        print("新しい鳥を追加しました")
                        startBirdTimer()
                        
                        print("新しい鳥を追加しました")
                    } else {
                        print("この鳥は既に当たっています")
                    }
                }
            }
         */
        for result in hitTestResults {
                let node = result.node
                print("スワイプ中にヒットしたノード: \(node.name ?? "unknown")")
                
            if let birdNode = birdNodes.first(where: { birdNode in
                birdNode.name == node.name ||
                birdNode == node ||
                birdNode.childNode(withName: node.name ?? "", recursively: true) != nil
            }) {
                print("鳥を見つけました")
                if !hitBirds.contains(birdNode) {
                    hitBirds.insert(birdNode, at: 0)
                    
                    if node.name?.contains("Object") == true {
                        delegate.score += 390
                    } else if node.name?.contains("Mesh") == true {
                        delegate.score += 3900
                    }
                    
                    print("スワイプ中に倒した! スコア: \(delegate.score)")
                    
                    removeBird(birdNode)
                    addBird()
                    startBirdTimer()
                    
                    print("新しい鳥を追加しました")
        
                    break // 一度ヒットしたら処理を終了
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
}
