//
//  3DTest.swift
//  Archer Golf
//
//  Created by Archer Hasbany on 10/4/23.
//

import SwiftUI
import SceneKit

struct GyroCubeView: View {
    var sensor: SwingSensorDevice
//    var gyro: SumGyro
    
    init(sensor: SwingSensorDevice) {
        self.sensor = sensor
//        gyro = SumGyro(sensor: sensor)
    }
    
    var body: some View {
        VStack {
            SceneKitCubeView(sensor: sensor)
                .frame(width: 300, height: 300)
        }
    }
}

struct SceneKitCubeView: UIViewRepresentable {
    var sensor: SwingSensorDevice
    
    @State private var xTotalRotation: Double = 0.0
    @State private var yTotalRotation: Double = 0.0
    @State private var zTotalRotation: Double = 0.0
    @State var lastUpdateDate = Date()

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.black
        
        // Create a cube geometry
        let cube = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.02)
        let cubeNode = SCNNode(geometry: cube)
        scene.rootNode.addChildNode(cubeNode)
        
        // Rotate the cube based on gyroscope readings
        cubeNode.eulerAngles = SCNVector3(CGFloat(xTotalRotation * .pi / 180), CGFloat(yTotalRotation * .pi / 180), CGFloat(zTotalRotation * .pi / 180))
        
        // Add a light source to visualize the cube's rotation
        let light = SCNLight()
        light.type = .omni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 10, 10)
        scene.rootNode.addChildNode(lightNode)
        // Start with initial rotation
        updateCubeRotation(uiView: sceneView)
        
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Calculate time elapsed since last update
        let currentTime = Date()
        let timeElapsed = currentTime.timeIntervalSince(lastUpdateDate)
        lastUpdateDate = currentTime

        // Accumulate the rotation based on gyro data and elapsed time
        xTotalRotation += sensor.gyroX * timeElapsed
        yTotalRotation += sensor.gyroY * timeElapsed
        zTotalRotation += sensor.gyroZ * timeElapsed

        // Update cube's rotation
        updateCubeRotation(uiView: uiView)
    }
    
    private func updateCubeRotation(uiView: SCNView) {
        if let cubeNode = uiView.scene?.rootNode.childNodes.first {
            cubeNode.eulerAngles = SCNVector3(CGFloat(xTotalRotation * .pi / 180), CGFloat(yTotalRotation * .pi / 180), CGFloat(zTotalRotation * .pi / 180))
        }
    }
}
