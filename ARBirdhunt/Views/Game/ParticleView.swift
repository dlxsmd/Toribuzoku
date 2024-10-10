//
//  ParticleView.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/04.
//

import SwiftUI
import SpriteKit

struct ParticleView: View {
    let size: CGSize
    
    private var scene: SKScene{
        let emitterNode = SKEmitterNode(fileNamed: "TitleBackgroundParticles")!
        let scene = SKScene(size: size)
        scene.backgroundColor = .clear
        scene.anchorPoint = CGPoint(x: 0.5, y: 0)
        scene.addChild(emitterNode)
        
        return scene
        
    }
    
    var body: some View {
        SpriteView(scene: scene,options: [.allowsTransparency])
    }
}

#Preview{
    ParticleView(size: CGSize(width: 300, height: 300))
}
