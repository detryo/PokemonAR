//
//  Scene.swift
//  PokemonAR
//
//  Created by Cristian Sedano Arenas on 24/9/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
    let remainingLabel = SKLabelNode()
    var timer : Timer?
    var targetsCreated = 0
    var targetCount = 0 {
        didSet{
            self.remainingLabel.text = "Miss: \(targetCount)"
        }
    }
    
    override func didMove(to view: SKView) {
        remainingLabel.fontSize = 30
        remainingLabel.fontName = "Avenir Next"
        remainingLabel.color = .white
        remainingLabel.position = CGPoint(x: 0, y: view.frame.midY-50)
        addChild(remainingLabel)
        targetCount = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { (timer) in
            self.createTarget()
        })
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func createTarget(){
        
        if targetsCreated == 25 {
            timer?.invalidate()
            timer = nil
            return
        }
        targetsCreated += 1
        targetCount += 1
    }
}
