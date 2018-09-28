//
//  ViewController.swift
//  PokemonAR
//
//  Created by Cristian Sedano Arenas on 24/9/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import GameplayKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - ARSKViewDelegate
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let random = GKRandomSource.sharedRandom()
        let pokemonId = random.nextInt(upperBound: 4) + 1
        
        return SKSpriteNode(imageNamed: "pokemon\(pokemonId)")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
       
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        
    }
}
