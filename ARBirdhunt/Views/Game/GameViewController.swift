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
    
    var countDown = 5
    var countDownTimer: Timer?
    
    var countdownLabel: UILabel!
    var overlayView: UIView!
    
    var lastHitTestTime: TimeInterval = 0
    let hitTestInterval: TimeInterval = 0.1 // 0.1秒ごとにヒットテストを実行
    
    var lastUpdateTime: TimeInterval = 0
    let updateInterval: TimeInterval = 0.1 // 0.1秒ごとに更新
    
    var comboTimelimit: TimeInterval = 5.0 //コンボ持続時間
    
    let birdTypes: [SCNScene?] = [
        SCNScene(named: "simple_bird.scn"),
        SCNScene(named: "king_bird.usdz"),
        SCNScene(named: "chicken_bird.obj")
    ]
    let birdWeights: [Float] = [80, 10, 10] // 出現確率: 80%, 10%, 10%
    var weightedChooser: WeightedChooser!
    
    var rotationeulerAngles = SCNVector3(0, 0, 0)
    
    var arrowImageView: UIImageView!
    
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
        
        //arrow view
        arrowImageView = UIImageView(image: UIImage(named: "Arrow"))
        arrowImageView.frame = CGRect(x: view.bounds.width / 2 - 25, y: view.bounds.height / 2, width: 50, height: 50)
        
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
        
        // 半透明の黒背景を作成
            overlayView = UIView(frame: view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.isHidden = true
            
            // カウントダウンラベルを作成
            countdownLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            countdownLabel.center = view.center
            countdownLabel.textAlignment = .center
            countdownLabel.font = UIFont.systemFont(ofSize: 72, weight: .bold)
            countdownLabel.textColor = .white
            countdownLabel.isHidden = true
        
        //重み付き抽選の初期化
        weightedChooser = WeightedChooser(weights: birdWeights)
        
        //arviewの初期設定
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = self

        
        view.addSubview(arView)
        view.addSubview(skView)
        view.addSubview(arrowImageView)
        view.addSubview(overlayView)
        view.addSubview(countdownLabel)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBirdTimer()
        prepareTimer()
        
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
        
        // 鳥を配置する距離の範囲（メートル単位）
        let minDistance: Float = 5.0
        let maxDistance: Float = 15.0
        let randomDistance = Float.random(in: minDistance...maxDistance)
        
        // 鳥の位置をランダムに計算
        let randomHorizontalAngle = Float.random(in: -Float.pi/4...Float.pi/4)  // 水平方向の角度を制限
        let randomVerticalAngle = Float.random(in: -Float.pi/6...Float.pi/6)    // 垂直方向の角度を制限
        
        let horizontalRotation = SCNMatrix4MakeRotation(randomHorizontalAngle, 0, 1, 0)
        let verticalRotation = SCNMatrix4MakeRotation(randomVerticalAngle, 1, 0, 0)
        let combinedRotation = SCNMatrix4Mult(horizontalRotation, verticalRotation)
        
        let rotatedForward = SCNVector3(
            x: cameraForward.x * Float(combinedRotation.m11) + cameraForward.y * Float(combinedRotation.m21) + cameraForward.z * Float(combinedRotation.m31),
            y: cameraForward.x * Float(combinedRotation.m12) + cameraForward.y * Float(combinedRotation.m22) + cameraForward.z * Float(combinedRotation.m32),
            z: cameraForward.x * Float(combinedRotation.m13) + cameraForward.y * Float(combinedRotation.m23) + cameraForward.z * Float(combinedRotation.m33)
        )
        
        let birdPosition = SCNVector3(
            cameraPosition.x + rotatedForward.x * randomDistance,
            cameraPosition.y + rotatedForward.y * randomDistance,
            cameraPosition.z + rotatedForward.z * randomDistance
        )
        
        newBirdNode.position = birdPosition
        
        // 鳥をカメラの方向に向ける
        newBirdNode.look(at: cameraPosition)
        
        // スケールを調整(3dmodelによって適切な大きさに調整)
        switch chosenIndex {
        case 0:
            newBirdNode.scale = SCNVector3(0.01, 0.01, 0.01)
            newBirdNode.name = "normalBird"
            rotationeulerAngles = SCNVector3(0, 0, 0)
        case 1:
            newBirdNode.scale = SCNVector3(0.05, 0.05, 0.05)
            newBirdNode.name = "specialBird"
            rotationeulerAngles = SCNVector3(0, 0, 0)
        case 2:
            newBirdNode.scale = SCNVector3(1, 1, 1)
            newBirdNode.name = "timerBird"
            rotationeulerAngles = SCNVector3(0, 0, 0)
        default:
            newBirdNode.scale = SCNVector3(0.01, 0.1, 0.01)
            newBirdNode.name = "normalBird"
            rotationeulerAngles = SCNVector3(0, 0, 0)
        }
        
        arView.scene.rootNode.addChildNode(newBirdNode)
        
        let moveAction = createRandomFlyingAction()
           newBirdNode.runAction(moveAction)
        
        birdNodes.append(newBirdNode)
        
        print("鳥を追加: \(newBirdNode.name!)")
    }

    func createRandomFlyingAction(duration: TimeInterval = 2.5, movementRange: CGFloat = 5.0) -> SCNAction {
        let createRandomMove = {
            let randomX = CGFloat.random(in: -movementRange...movementRange)
            let randomY = CGFloat.random(in: -movementRange/2...movementRange/2)
            let randomZ = CGFloat.random(in: -movementRange...movementRange)
            return SCNAction.move(by: SCNVector3(randomX, randomY, randomZ), duration: duration)
        }

        let moves = (0..<4).map { _ in createRandomMove() }
        let sequence = SCNAction.sequence(moves)
        return SCNAction.repeatForever(sequence)
    }
    
    //countDown to gameStart
    func prepareTimer(){
        overlayView.isHidden = false
        countdownLabel.isHidden = false
        updateCountdownDisplay()
        
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.countDown -= 1
            self.updateCountdownDisplay()
            
            if self.countDown <= 0 {
                timer.invalidate()
                self.overlayView.isHidden = true
                self.countdownLabel.isHidden = true
                self.timelimit()
            }
        }
    }
    
    func updateCountdownDisplay() {
        countdownLabel.text = "\(countDown)"
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
            if time - lastUpdateTime >= updateInterval {
                updateBirdOrientation()
                updateArrowDirection()
                lastUpdateTime = time
            }
        }
    
    func updateArrowDirection() {
        guard let birdNode = birdNodes.first, let cameraNode = arView.pointOfView else { return }
        
        let cameraPosition = cameraNode.worldPosition
        let birdPosition = birdNode.worldPosition
        
        // カメラから鳥への方向ベクトルを計算
        let directionToBird = SCNVector3(
            x: birdPosition.x - cameraPosition.x,
            y: birdPosition.y - cameraPosition.y,
            z: birdPosition.z - cameraPosition.z
        )
        
        // カメラの向きを考慮した方向ベクトルを計算
        let cameraTransform = cameraNode.transform
        let cameraForward = SCNVector3(-cameraTransform.m31, -cameraTransform.m32, -cameraTransform.m33)
        let cameraRight = SCNVector3(cameraTransform.m11, cameraTransform.m12, cameraTransform.m13)
        let cameraUp = SCNVector3(cameraTransform.m21, cameraTransform.m22, cameraTransform.m23)
        
        // カメラ空間での鳥の方向を計算
        let dotForward = SCNVector3DotProduct(directionToBird, cameraForward)
        let dotRight = SCNVector3DotProduct(directionToBird, cameraRight)
        
        // 角度を計算
        let angle = atan2(dotRight, dotForward)
        
        // UIImageViewを回転
        DispatchQueue.main.async {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        }
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




