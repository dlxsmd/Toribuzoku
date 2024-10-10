import UIKit
import ARKit
import SwiftUI
import SceneKit



class GameViewController: UIViewController, ARSCNViewDelegate, ObservableObject, SCNPhysicsContactDelegate {
    var arView: ARSCNView!
    var skView: SKView!
    
    var birdNode: SCNNode?
    var lastTouchedBody: SCNNode?
    
    var delegate: GameViewControllerDelegate!
    
    var sliceSFX: AVAudioPlayer!
    var swipeParticle = SKEmitterNode(fileNamed: "Slice")!
    

    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            
            let sliceSFXPath = Bundle.main.path(forResource: "slice", ofType: "mp3")!
            sliceSFX = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sliceSFXPath))
            sliceSFX.prepareToPlay()
            
            // ARSCNViewの初期化
            arView = ARSCNView(frame: self.view.bounds)
            arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            arView.delegate = self
            arView.autoenablesDefaultLighting = true
            arView.backgroundColor = UIColor.clear
        
            // SKViewの初期化
            skView = SKView(frame: self.view.bounds)
            skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            skView.backgroundColor = UIColor.clear
            skView.allowsTransparency = true
            
            // パーティクルの設定
            let scene = SKScene(size: view.frame.size)
            scene.backgroundColor = .clear
            swipeParticle.particleBlendMode = .add
            swipeParticle.targetNode = scene
            scene.addChild(swipeParticle)
            skView.presentScene(scene)
            
            view.addSubview(arView)
            view.addSubview(skView)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = self
        
        addBird()
        timelimit()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           // Ensure ARSCNView takes up the full screen
        arView.frame = view.bounds
       }

//    func startBirdTimer() {
//        // 5秒ごとに鳥を削除し、再度追加する
//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
//            self.removeBird()
//            self.addBird()
//        }
//    }

    func removeBird() {
        // 既存の鳥を削除
        if let bird = birdNode {
            bird.removeFromParentNode()
            print("鳥を削除しました。")
        }
    }
    //random appearing
    //reg normal score - 1pt  80%
    //cuckoo extra time - 5s 5%
    //golden high score - normal * 5 pt 15%

    //ok
    func addBird() {
        // birdObjectsからランダムなSCNSceneを取得
        if let randomScene = birdObjects.randomElement() as? SCNScene {
            // 新しい鳥を作成し、birdNodeに代入
            birdNode = randomScene.rootNode.childNode(withName: "SkinnedMeshes", recursively: true) ?? randomScene.rootNode

            if let birdNode = birdNode {
                // 鳥が正しく取得できていれば、シーンに追加
                let moveDistance: Float = 400.0 // 移動距離
                let randomX = Float.random(in: -moveDistance...moveDistance)
                let randomY = Float.random(in: -moveDistance...moveDistance)
                birdNode.position = SCNVector3(randomX, randomY, -400.0)

                birdNode.name = "bird"
                arView.scene.rootNode.addChildNode(birdNode)

                // 鳥に飛ぶアクションを適用
                let moveAction = createRealisticFlyingAction() // ランダム移動アクション
                birdNode.runAction(moveAction)

                print("鳥を追加: \(birdNode.position)")
            }
        } else {
            print("鳥のシーンが見つかりません。")
        }
    }


//
//    func createDiagonalFlyingAction() -> SCNAction {
//        let movePath = SCNAction.sequence([
//            SCNAction.move(by: SCNVector3(1, 1, 0), duration: 1.0),
//            SCNAction.move(by: SCNVector3(-1, -1, 0), duration: 1.0)
//        ])
//        return SCNAction.repeatForever(movePath)
//    }
    
    func createRealisticFlyingAction() -> SCNAction {
        let randomRotation = SCNAction.rotateBy(x: 0,
                                                 y: CGFloat.random(in: -CGFloat.pi...CGFloat.pi),
                                                 z: 0,
                                                 duration: 5.0)

        let moveRandomly = SCNAction.run { node in
            let moveDistance: Float = 400.0
            let randomX = Float.random(in: -moveDistance...moveDistance)
            let randomY = Float.random(in: -moveDistance...moveDistance)
            let fixedZPosition: Float = node.position.z
            let newPosition = SCNVector3(randomX, randomY, fixedZPosition)
            node.position = newPosition
        }

        let moveAndRotate = SCNAction.sequence([randomRotation, moveRandomly])
        return SCNAction.repeatForever(moveAndRotate)
    }
    
    func timelimit() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.delegate.timeRemaining -= 1
            if self.delegate.timeRemaining <= 0 {
                timer.invalidate()
                self.delegate.gameOver = true
                self.arView.session.pause()
            }
        }
    }
    

    func session(_ session: ARSession, didFailWithError error: Error) {
        print("ARセッションのエラー: \(error.localizedDescription)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        print("ARセッションが中断されました。")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        print("ARセッションが再開されました。")
    }
}



