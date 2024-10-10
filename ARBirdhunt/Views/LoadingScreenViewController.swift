//
//  LoadingScreenViewController.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/09.
//

import UIKit

class LoadingScreenViewController: UIViewController {
    
    let loadingAssets = [
        "loading_swift",
        "loading_meet",
        "loading_yakitori"
    ]
    
    let tipsMessages = [
        "Try to catch the bird in the center of the screen",
        "The more birds you catch, the higher your score will be",
        "The game is over when the time runs out"
    ]
    
    private var currentImageIndex = 0
    private var currentTipsIndex = 0
    
    private var imageView: UIImageView!
    private var tipsLabel: UILabel!
    private var circlesStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startTimers()
    }
    
    private func setupUI() {
        // 背景色を設定
        view.backgroundColor = .black
        
        // テキストラベルを設定
        let tipsTitleLabel = UILabel()
        tipsTitleLabel.text = "Tips..."
        tipsTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        tipsTitleLabel.textColor = .white
        tipsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tipsLabel = UILabel()
        tipsLabel.textColor = .white
        tipsLabel.frame.size.height = 50
        tipsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // イメージビューを設定
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // サークルを配置するスタックビューを設定
        circlesStackView = UIStackView()
        circlesStackView.axis = .horizontal
        circlesStackView.spacing = 15
        circlesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<loadingAssets.count {
            let circleView = UIView()
            circleView.backgroundColor = .white
            circleView.layer.cornerRadius = 25
            circleView.frame.size = CGSize(width: 50, height: 50)
            circlesStackView.addArrangedSubview(circleView)
        }
        
        // サブビューを追加
        view.addSubview(tipsTitleLabel)
        view.addSubview(tipsLabel)
        view.addSubview(imageView)
        view.addSubview(circlesStackView)
        
        // Auto Layout を設定
        NSLayoutConstraint.activate([
            tipsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tipsTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tipsLabel.topAnchor.constraint(equalTo: tipsTitleLabel.bottomAnchor, constant: 20),
            tipsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: tipsLabel.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            circlesStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            circlesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func startTimers() {
        // 画像を更新するタイマー
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.currentImageIndex = (self.currentImageIndex + 1) % self.loadingAssets.count
            self.updateLoadingImage()
        }
        
        // ヒントを更新するタイマー
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.currentTipsIndex = (self.currentTipsIndex + 1) % self.tipsMessages.count
            self.updateTips()
        }
    }
    
    private func updateLoadingImage() {
        imageView.image = UIImage(named: loadingAssets[currentImageIndex])
        
        // サークルの表示を更新
        for (index, subview) in circlesStackView.arrangedSubviews.enumerated() {
            if index == currentImageIndex {
                subview.isHidden = false
            } else {
                subview.isHidden = true
            }
        }
    }
    
    private func updateTips() {
        tipsLabel.text = tipsMessages[currentTipsIndex]
    }
}
