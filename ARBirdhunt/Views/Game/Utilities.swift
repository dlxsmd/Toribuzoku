//
//  Utilities.swift
//  ARBirdhunt
//
//  Created by Yuki Imai on 2024/10/12.
//

import Foundation
import ARKit
import SceneKit


extension SCNVector3 {
    func length() -> Float {
        return sqrt(x*x + y*y + z*z)
    }
    
    func normalized() -> SCNVector3 {
        let len = length()
        return len > 0 ? self / len : SCNVector3(0, 0, 0)
    }
    
    static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
    }
    
    static func -(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
    }
    
    static func *(vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x * scalar, vector.y * scalar, vector.z * scalar)
    }
    
    static func /(vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
    
    func dot(_ vector: SCNVector3) -> Float {
        return x * vector.x + y * vector.y + z * vector.z
    }
}

extension SCNQuaternion {
    init(from: SCNVector3, to: SCNVector3) {
        let dot = from.normalized().dot(to.normalized())
        let angle = acos(dot)
        let axis = from.cross(to).normalized()
        self.init(axis.x, axis.y, axis.z, angle)
    }
    
    func slerp(_ q: SCNQuaternion, t: Float) -> SCNQuaternion {
        var result = SCNQuaternion(x: 0, y: 0, z: 0, w: 1)
        var cosHalfTheta = x * q.x + y * q.y + z * q.z + w * q.w
        if cosHalfTheta < 0 {
            cosHalfTheta = -cosHalfTheta
            result.x = -q.x; result.y = -q.y; result.z = -q.z; result.w = -q.w
        } else {
            result = q
        }
        if abs(cosHalfTheta) >= 1.0 {
            return self
        }
        let halfTheta = acos(cosHalfTheta)
        let sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta)
        if abs(sinHalfTheta) < 0.001 {
            return SCNQuaternion(
                x: (x * 0.5 + result.x * 0.5),
                y: (y * 0.5 + result.y * 0.5),
                z: (z * 0.5 + result.z * 0.5),
                w: (w * 0.5 + result.w * 0.5)
            )
        }
        let ratioA = sin((1 - t) * halfTheta) / sinHalfTheta
        let ratioB = sin(t * halfTheta) / sinHalfTheta
        return SCNQuaternion(
            x: (x * ratioA + result.x * ratioB),
            y: (y * ratioA + result.y * ratioB),
            z: (z * ratioA + result.z * ratioB),
            w: (w * ratioA + result.w * ratioB)
        )
    }
}

extension SCNVector3 {
    func cross(_ v: SCNVector3) -> SCNVector3 {
        return SCNVector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)
    }
}
