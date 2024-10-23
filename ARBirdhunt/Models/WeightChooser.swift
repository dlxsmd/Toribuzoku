//
//  WeightChooser.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/11.
//

class WeightedChooser {
    private let weights: [Float]
    private let totalWeight: Float

    init(weights: [Float]) {
        self.weights = weights
        self.totalWeight = weights.reduce(0, +)
    }

    func choose() -> Int {
        let randomValue = Float.random(in: 0..<totalWeight)
        var accumulatedWeight: Float = 0

        for (index, weight) in weights.enumerated() {
            accumulatedWeight += weight
            if randomValue < accumulatedWeight {
                return index
            }
        }

        return weights.count - 1 // フォールバック（通常ここには到達しない）
    }
}
