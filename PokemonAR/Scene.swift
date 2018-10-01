//
//  Scene.swift
//  PokemonAR
//
//  Created by Cristian Sedano Arenas on 24/9/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import SpriteKit
import ARKit
import GameplayKit

class Scene: SKScene {
    
    let remainingLabel = SKLabelNode()
    var timer : Timer?
    var targetsCreated = 0
    var targetCount = 0 {
        didSet{
            self.remainingLabel.text = "Miss: \(targetCount)"
        }
    }
    
    let deathSound = SKAction.playSoundFileNamed("QuickDeath", waitForCompletion: false)
    let startTime = Date()
    
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
        
        guard let touche = touches.first else { return }
        let location = touche.location(in: self)
        print("The User touche in: (\(location.x), \(location.y))")
        
        let hit = nodes(at: location)
        
        if let sprite = hit.first{
            let scaleOut = SKAction.scale(to: 2, duration: 0.4)
            let fadeOut = SKAction.fadeOut(withDuration: 0.4)
            let groupAction = SKAction.group([scaleOut, fadeOut, deathSound])
            let remove = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([groupAction, remove])
            
            sprite.run(sequenceAction)
            
            targetCount -= 1
            if targetsCreated == 25 && targetCount == 0{
                gameOver()
            }
        }
    }
    
    func createTarget(){
        
        if targetsCreated == 25 {
            timer?.invalidate()
            timer = nil
            return
        }
        targetsCreated += 1
        targetCount += 1
        
        guard let scenView = self.view as? ARSKView else { return }
        
        let random = GKRandomSource.sharedRandom()
        
        let rotateX = float4x4(SCNMatrix4MakeRotation(2.0 * Float.pi * random.nextUniform(), 1, 0, 0))
        
        let rotateY = float4x4(SCNMatrix4MakeRotation(2.0 * Float.pi * random.nextUniform(), 0, 1, 0))
        
        let rotation = simd_mul(rotateX, rotateY)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = 1.5 * random.nextUniform() + 0.5
        
        let finalTransform = simd_mul(rotation, translation)
        
        let anchor = ARAnchor(transform: finalTransform)
        
        scenView.session.add(anchor: anchor)
    }
    
    func gameOver(){
        remainingLabel.removeFromParent()
        
        let gameOver = SKSpriteNode.init(imageNamed: "gameover")
        addChild(gameOver)
        
        let timeTaken = Date().timeIntervalSince(startTime)
        
        let timeTakenLabel = SKLabelNode.init(text: "It has taken you: \(Int(timeTaken)) seconds")
        timeTakenLabel.fontSize = 40
        timeTakenLabel.color = .white
        timeTakenLabel.position = CGPoint(x: +view!.frame.maxX - 50,
                                          y: -view!.frame.midY + 50)
        
        addChild(timeTakenLabel)
    }
}
