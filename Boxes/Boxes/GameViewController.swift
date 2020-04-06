//
//  GameViewController.swift
//  Boxes
//
//  Created by Devesh Shetty on 05/04/20.
//  Copyright © 2020 Devesh Shetty. All rights reserved.
//

import UIKit
import SceneKit

final class GameViewController: UIViewController {
    // MARK: Properties
    
    private let game = Game()

    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grab the controller's view as a SceneKit view.
        guard let scnView = view as? SCNView else { fatalError("Unexpected view class") }
        
        // Set our background color to a light gray color.
        scnView.backgroundColor = UIColor.lightGray
        
        // Ensure the view controller can display our game's scene.
        scnView.scene = game.scene
        
        // Ensure the game can manage updates for the scene.
        scnView.delegate = game
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tap)
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
    
    /// Causes the boxes to jump if a tap is detected.
    @objc private func handleTap(_: UITapGestureRecognizer) {
        game.jumpBoxes()
    }
}
