import UIKit
import ARKit
import SwiftUI
import SceneKit



class GameViewController: UIViewController, ARSCNViewDelegate, ObservableObject, SCNPhysicsContactDelegate {
    var arView: ARSCNView!
    var skView: SKView!
    
    var birdNodes: [SCNNode] = []
    var hitBirds:[SCNNode] = []
    
    var delegate: GameViewControllerDelegate!
    
    var sliceSFX: AVAudioPlayer!
    var swipeParticle: SKEmitterNode!
    
    var birdTimer: Timer?
    var comboTimer: Timer?
    var comboTimelimit: TimeInterval = 3.0 //コンボ持続時間
    
    let birdTypes: [SCNScene?] = [
        SCNScene(named: "simple_bird.scn"),
        SCNScene(named: "king_bird.usdz"),
        SCNScene(named: "chicken_bird.obj")
    ]
    let birdWeights: [Float] = [90, 5, 5] // 出現確率: 90%, 5%, 5%
    var weightedChooser: WeightedChooser!
    
    var rotationeulerAngles = SCNVector3(0, 0, 0)
    
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
        swipeParticle = SKEmitterNode(fileNamed: "Slice")!
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        swipeParticle.particleBlendMode = .add
        swipeParticle.targetNode = scene
        scene.addChild(swipeParticle)
        skView.presentScene(scene)
        
        //光源の設定
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 10, 10)
        arView.scene.rootNode.addChildNode(lightNode)
        
        //重み付き抽選の初期化
        weightedChooser = WeightedChooser(weights: birdWeights)
        
        //arviewの初期設定
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = self

        
        view.addSubview(arView)
        view.addSubview(skView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startBirdTimer()
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



    func startBirdTimer() {
        birdTimer?.invalidate()
        birdTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if let firstBird = self.birdNodes.first {
                self.removeBird(firstBird)
            }
            
            self.addBird()
        }
    }

    func removeBird(_ birdNode: SCNNode) {
        birdNode.removeFromParentNode()
        if let index = birdNodes.firstIndex(of: birdNode) {
            birdNodes.remove(at: index)
            hitBirds.removeAll(where: { $0 == birdNode })
        }
        print("鳥を削除しました: \(birdNode.name ?? "unknown")")
    }

    func addBird() {
        let chosenIndex = weightedChooser.choose()
        let birdType = birdTypes[chosenIndex]
        guard let birdScene = birdType else {
            print("鳥のシーンを読み込めませんでした: \(birdType)")
            return
        }
        let newBirdNode = birdScene.rootNode.childNode(withName: "bird", recursively: true) ?? birdScene.rootNode
        
        // カメラの現在の位置と向きを取得
        guard let currentFrame = arView.session.currentFrame else {
            print("現在のフレームを取得できません")
            return
        }
        
        let cameraTransform = currentFrame.camera.transform
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        
        // カメラの前方ベクトルを計算
        let cameraForward = SCNVector3(-cameraTransform.columns.2.x, -cameraTransform.columns.2.y, -cameraTransform.columns.2.z)
        
        // 鳥を配置する距離（メートル単位）
        let distanceInFront: Float = 10.0
        
        // 鳥の位置を計算
        let birdPosition = SCNVector3(
            cameraPosition.x + cameraForward.x * distanceInFront,
            cameraPosition.y + cameraForward.y * distanceInFront,
            cameraPosition.z + cameraForward.z * distanceInFront
        )
        
        newBirdNode.position = birdPosition
        
        // 鳥をカメラの方向に向ける
        newBirdNode.look(at: cameraPosition)
        
        // スケールを調整(3dmodelによって適切な大きさに調整)
        switch chosenIndex {
        case 0:
            newBirdNode.scale = SCNVector3(0.01, 0.01, 0.01)
            rotationeulerAngles = SCNVector3(Float.pi, 0, 0)
        case 1:
            newBirdNode.scale = SCNVector3(0.1, 0.1, 0.1)
            rotationeulerAngles = SCNVector3(0, 0, Float.pi / 2)
        case 2:
            newBirdNode.scale = SCNVector3(0.5, 0.5, 0.5)
            rotationeulerAngles = SCNVector3(0, 0, 0)
            default:
            newBirdNode.scale = SCNVector3(0.01, 0.01, 0.01)
            rotationeulerAngles = SCNVector3(0, 0, 0)
        }
        
        
        newBirdNode.name = "bird"
        arView.scene.rootNode.addChildNode(newBirdNode)
        
        let moveAction = createRealisticFlyingAction(fixedDistanceFromCamera: 10.0)
        newBirdNode.runAction(moveAction)
        
        birdNodes.append(newBirdNode)
        
        print("鳥を追加: \(birdType)")
    }
    
    func createRealisticFlyingAction(fixedDistanceFromCamera: Float) -> SCNAction {
        let randomRotation = SCNAction.rotateBy(x: 0,
                                                y: CGFloat.random(in: -CGFloat.pi...CGFloat.pi),
                                                z: 0,
                                                duration: 5.0)

        let moveRandomly = SCNAction.run { node in
            let moveDistance: Float = 2.0 // 移動距離を小さくする
            let randomX = Float.random(in: -moveDistance...moveDistance)
            let randomY = Float.random(in: -moveDistance...moveDistance)
            
            // カメラからの距離を固定するために、球面座標系を使用
            let theta = atan2(randomY, randomX)
            let phi = acos(randomY / fixedDistanceFromCamera)
            
            let newX = fixedDistanceFromCamera * sin(phi) * cos(theta)
            let newY = fixedDistanceFromCamera * sin(phi) * sin(theta)
            let newZ = fixedDistanceFromCamera * cos(phi)
            
            let newPosition = SCNVector3(newX, newY, -newZ) // Z軸を反転させて手前に表示
            let moveAction = SCNAction.move(to: newPosition, duration: 5.0)
            node.runAction(moveAction)
        }

        let moveAndRotate = SCNAction.sequence([randomRotation, moveRandomly])
        return SCNAction.repeatForever(moveAndRotate)
    }
    
    func timelimit() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.delegate.timeRemaining -= 1
            if self.delegate.timeRemaining <= 0 {
                timer.invalidate()
                self.birdTimer?.invalidate()
                self.arView.session.pause()
                self.delegate.gameOver = true
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        updateBirdOrientation()
    }

    func updateBirdOrientation() {
        guard let birdNode = birdNodes.first, let cameraNode = arView.pointOfView else { return }
        
        // カメラの位置を取得
        let cameraPosition = cameraNode.worldPosition
        
        // 鳥の位置を取得
        let birdPosition = birdNode.worldPosition
        
        // カメラから鳥への方向ベクトルを計算
        let directionToCamera = SCNVector3(
            x: cameraPosition.x - birdPosition.x,
            y: 0, // Y軸回転のみを考慮する場合
            z: cameraPosition.z - birdPosition.z
        )
    
        // 鳥をカメラの方向に向ける
        birdNode.look(at: SCNVector3(
            x: birdPosition.x + directionToCamera.x,
            y: birdPosition.y,
            z: birdPosition.z + directionToCamera.z
        ))
            
        birdNode.eulerAngles = rotationeulerAngles

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




