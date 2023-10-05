//
//  3DTest.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import SwiftUI
import SceneKit

struct GyroCubeView: UIViewRepresentable {

    var sensor: SwingSensorDevice
    init(sensor: SwingSensorDevice)
    {
        self.sensor = sensor
    }
    private var accumulatedRotation = AccumulatedRotation()
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.black
        
        // Create a cube geometry
        let cube = SCNBox(width: 0.1, height: 0.005, length: 0.1, chamferRadius: 0.00)
        let cubeNode = SCNNode(geometry: cube)
        scene.rootNode.addChildNode(cubeNode)
        
        // Rotate the cube based on gyroscope readings
        cubeNode.eulerAngles = SCNVector3(CGFloat(sensor.gyroX * .pi / 180), CGFloat(sensor.gyroY * .pi / 180), CGFloat(sensor.gyroZ * .pi / 180))
        
        // Add a light source to visualize the cube's rotation
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 10, 10)
        scene.rootNode.addChildNode(lightNode)

        updateCubeRotation(uiView: sceneView)
        
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Calculate time elapsed since last update
        let currentTime = Date()
        let timeElapsed = currentTime.timeIntervalSince(accumulatedRotation.lastUpdateDate)
        accumulatedRotation.lastUpdateDate = currentTime

        // Accumulate the rotation based on gyro data and elapsed time
        accumulatedRotation.xTotalRotation += sensor.gyroX * timeElapsed
        accumulatedRotation.yTotalRotation += sensor.gyroY * timeElapsed
        accumulatedRotation.zTotalRotation += sensor.gyroZ * timeElapsed

        // Update cube's rotation
        updateCubeRotation(uiView: uiView)
    }
    
    private func updateCubeRotation(uiView: SCNView) {
        if let cubeNode = uiView.scene?.rootNode.childNodes.first {
            cubeNode.eulerAngles = SCNVector3(CGFloat(accumulatedRotation.xTotalRotation * .pi / 180), CGFloat(accumulatedRotation.yTotalRotation * .pi / 180), CGFloat(accumulatedRotation.zTotalRotation * .pi / 180))
        }
    }
}

class AccumulatedRotation: Observable {
    var xTotalRotation: Double = 0.0
    var yTotalRotation: Double = 0.0
    var zTotalRotation: Double = 0.0
    var lastUpdateDate = Date()
}
