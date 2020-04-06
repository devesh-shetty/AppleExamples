//
//  ParticleComponent.swift
//  Boxes
//
//  Created by Devesh Shetty on 05/04/20.
//  Copyright © 2020 Devesh Shetty. All rights reserved.
//

import SpriteKit
import SceneKit
import GameplayKit

final class ParticleComponent: GKComponent {
    // MARK: Properties
    
    /// A convenience property to access the entity's geometry component
    private var geometryComponent: GeometryComponent? {
        entity?.component(ofType: GeometryComponent.self)
    }
    
    /// Keeps track of whether the box has particle effect or not.
    private var boxHasParticleEffect = false
    
    /// Creates and manages the box's particle effect.
    private let particleEmitter: SCNParticleSystem
        
    /// The light attached to the box that illuminates its surroundings.
    private let boxLight = SCNLight()
    
    /**
     The brightness of the box's light. Changes the light's brightness when
     changed.
     */
    private var lightBrightness: CGFloat = 1 {
        didSet {
            boxLight.color = SKColor(white: lightBrightness, alpha: 1)
        }
    }
    
    /// Generates random numbers. Used to make the light flicker randomly.
    private let randomSource = GKRandomSource()
    
    /**
     Returns a light brightness slightly closer to the target light
     brightness than the current brightness. This is used to produce a
     smooth, yet still random flickering effect, making it feel realistic.
     
     This is a property because it's idempotent.
     */
    private var nextLightBrightness: CGFloat {
        /*
         If the light's brightness is below target, return an increased
         brightness. Otherwise, return a decreased brightness.
         */
        let delta: CGFloat = lightBrightness < targetLightBrightness ? 0.025 : -0.025
        return lightBrightness + delta
    }
    
    /// The brightness that the light is attempting to match.
    private var targetLightBrightness: CGFloat = 0.5
        
    // MARK: Initialization
    
    init(particleName: String) {
        // Create the particle emitter.
        particleEmitter = SCNParticleSystem(named: particleName, inDirectory: "/")!
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func update(deltaTime _: TimeInterval) {
        /*
         Ensure that the particle system and light will properly attach when
         the geometry node is added, even if it is not available when the
         component is constructed.
         */
        updateGeometryComponent()
        
        // Generate a new target brightness for the light every frame.
        targetLightBrightness = nextTargetLightBrightness()
        
        // Update the light's brightness every frame, causing the light to flicker.
        lightBrightness = nextLightBrightness
    }
    
    /**
     Attaches the particle emitter and light to the box if the entity has a geometry component and has not had them attached previously.
     */
    func updateGeometryComponent() {
        /*
         If the geometry component has been created, but the particle effect
         has not been attached to the box yet, then add the particle system
         and light to the box node.
         */
        if let geometryComponent = geometryComponent, !boxHasParticleEffect {
            geometryComponent.geometryNode.addParticleSystem(particleEmitter)
            geometryComponent.geometryNode.light = boxLight
        }
        
        /*
         Update the flag indicating if the particle effect has been attached
         to the box, so the next call to `updateGeometryComponent(_:)` has
         accurate information about the state of the geometry component.
         */
        boxHasParticleEffect = geometryComponent != nil
    }
    
    // MARK: Light Flickering Algorithm
    
    /**
     Randomly adjusts the light's target brightness, the brightness that
     the light is attempting to match.
     
     This is a method because it is not idempotent, since it uses a random
     source to produce different results each time it is called.
     */
    func nextTargetLightBrightness() -> CGFloat {
        // Randomly decide to increase or decrease the light's target brightness.
        let increaseLightTargetBrightness = randomSource.nextBool()
        let delta: CGFloat = increaseLightTargetBrightness ? 0.2 : -0.2
        
        // Calculate the adjusted value.
        let newTargetLightBrightness = targetLightBrightness + delta
        
        // Keep the light's target brightness between 0 and 1.
        let clampedLightBrightness = (newTargetLightBrightness...newTargetLightBrightness).clamped(to: (0...1)).lowerBound
        
        return clampedLightBrightness
    }
}
