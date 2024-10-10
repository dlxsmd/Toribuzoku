//
//  GameViewController+SwipeGesture.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/05.
//

import SwiftUI
import ARKit

extension GameViewController: ARSessionDelegate {
    private var isBirdNodeActive: Bool {
        return birdNode != nil
    }

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
        
        // スワイプ中の位置でヒットテストを実行
        let swipeLocation = touch.location(in: arView)
        
        let hitTestResults = arView.hitTest(swipeLocation, options: [
            SCNHitTestOption.boundingBoxOnly: true,
            SCNHitTestOption.ignoreHiddenNodes: false
        ])
        
        if let result = hitTestResults.first {
            let node = result.node
            print("スワイプ中にヒットしたノード: \(node.name ?? "unknown")")
            
            if node.name?.contains("Object") == true || node.name?.contains("Mesh") == true && isBirdNodeActive {
                node.name?.contains("Object") == true ? (delegate.score += 390) : (delegate.score += 3900)
                print("スワイプ中に倒した! スコア: \(delegate.score)")
                
                birdNode?.removeFromParentNode()
                DispatchQueue.main.async {
                    self.birdNode = nil // フラグを更新
                    self.addBird()
                }
                playSwipeSFX()
            }        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeParticle.particleBirthRate = 0
    }

    func playSwipeSFX() {
        // スワイプ音を再生
        sliceSFX.play()
    }
}
