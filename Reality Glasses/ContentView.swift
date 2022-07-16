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
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func createBox() -> Entity {
        // Craate mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        
        // Create entity based on mesh
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    func createSphere(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // Craate sphere mesh
        let sphere = MeshResource.generateSphere(radius: 0.075)
        
        // Create sphere entity
        let sphereEntity = ModelEntity(mesh: sphere)
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
        faceAnchor.addChild(createSphere(y: 0.25))
        
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
