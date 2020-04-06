//
//  PlayerControlComponent.swift
//  Boxes
//
//  Created by Devesh Shetty on 05/04/20.
//  Copyright © 2020 Devesh Shetty. All rights reserved.
//

import GameplayKit
import SceneKit

final class PlayerControlComponent: GKComponent {
    // MARK: Properties
    
    /// A convenience property for the entity's geometry component.
    private var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    // MARK: Methods
    
    /// Tells this entity's geometry component to jump.
    func jump() {
        let jumpVector = SCNVector3(x: 0, y: 2, z: 0)
        geometryComponent?.applyImpulse(jumpVector)
    }
}
