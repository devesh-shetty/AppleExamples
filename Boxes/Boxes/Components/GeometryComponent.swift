//
//  GeometryComponent.swift
//  Boxes
//
//  Created by Devesh Shetty on 05/04/20.
//  Copyright © 2020 Devesh Shetty. All rights reserved.
//

import SceneKit
import GameplayKit

final class GeometryComponent: GKComponent {
    // MARK: Properties
    
    /// A reference to the box in the scene that the entity controls.
    let geometryNode: SCNNode
    
    // MARK: Initialization
    
    init(geometryNode: SCNNode) {
        self.geometryNode = geometryNode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    /// Applies an upward impulse to the entity's box node, causing it to jump.
    func applyImpulse(_ vector: SCNVector3) {
        geometryNode.physicsBody?.applyForce(vector, asImpulse: true)
    }
}
