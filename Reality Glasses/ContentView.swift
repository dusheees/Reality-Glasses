//
//  ContentView.swift
//  Reality Glasses
//
//  Created by Андрей on 16.07.2022.
//

import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all).onTapGesture {
            // Create circle mesh
            let circle = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)

            switch ARViewContainer.countForColor {
            case 0:
                ARViewContainer.colorForMaterial = .red
            case 1:
                ARViewContainer.colorForMaterial = .purple
            default:
                ARViewContainer.colorForMaterial = .blue
            }
            
            // Create material
            let material = SimpleMaterial(color: ARViewContainer.colorForMaterial, isMetallic: true)

            for circleEntity in [ARViewContainer.leftCircleEntity, ARViewContainer.rightCircleEntity] {
                circleEntity.components[ModelComponent.self] = ModelComponent(mesh: circle, materials: [material])
            }
            
            ARViewContainer.countForColor = (ARViewContainer.countForColor + 1) % 3
        }
    }
}

struct ARViewContainer: UIViewRepresentable {    
    static var countForColor = 0
    static var colorForMaterial: UIColor!
    
    static let leftCircleEntity = ARViewContainer.createCircle(x: -0.035, y: 0.025, z: 0.06)
    static let rightCircleEntity = ARViewContainer.createCircle(x: 0.035, y: 0.025, z: 0.06)
            
    func createBox(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // Craate mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        
        // Create material
        let material = SimpleMaterial(color: .black, isMetallic: true)
        
        // Create entity based on mesh
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.position = SIMD3(x, y, z)
        entity.scale.x = 0.12
        entity.scale.y = 0.03
        entity.scale.z = 0.01
        
        return entity
    }
    
    static func createCircle(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // Create circle mesh
        let circle = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)

        // Create material
        let material = SimpleMaterial(color: .blue, isMetallic: true)

        // Create entity
        let circleEntity = ModelEntity(mesh: circle, materials: [material])
        circleEntity.position = SIMD3(x, y, z)
        circleEntity.scale.x = 1.1
        circleEntity.scale.z = 0.01

        circleEntity.name = "Circle"

        return circleEntity
    }
    
    func createSphere(x: Float = 0,
                      y: Float = 0,
                      z: Float = 0,
                      color: UIColor = .red,
                      radius: Float = 1) -> Entity {
        // Craate sphere mesh
        let sphere = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, isMetallic: true)
        
        // Create sphere entity
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        sphereEntity.position = SIMD3(x, y, z)
        
        return sphereEntity
    }
    
    func makeUIView(context: Context) -> ARView {
        
        // Create AR view
        let arView = ARView(frame: .zero)
        
        // Check that face tracking configeration is supported
        guard ARFaceTrackingConfiguration.isSupported else {
            print(#line, #function, "Sorry, face tracking is not supported by your device")
            return arView
        }
        
        // Create face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run face tracking session
        arView.session.run(configuration, options: [])
        
        // Create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        // Add box to the face anchor
        faceAnchor.addChild(createBox(y: 0.035, z: 0.059))
        faceAnchor.addChild(ARViewContainer.leftCircleEntity)
        faceAnchor.addChild(ARViewContainer.rightCircleEntity)
        faceAnchor.addChild(createSphere(z: 0.06, radius: 0.025))
        
        // Face anchor to the scene
        arView.scene.anchors.append(faceAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
