//
//  GameOverView.swift
//  Project8
//
//  Created by Claudio Carnino on 28/12/2017.
//  Copyright © 2017 Cla. All rights reserved.
//

import Cocoa


final class GameOverView: NSView {
    
    func startEmitting() {
        
        wantsLayer = true
        
        let title = NSTextField(labelWithString: "Game over")
        title.font = NSFont.systemFont(ofSize: 96, weight: .heavy)
        title.textColor = .white
        
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor)
        title.centerYAnchor.constraint(equalTo: centerYAnchor)
        
        layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        createEmitter()
    }
    
    
    private func createEmitterCell(color: NSColor) -> CAEmitterCell {
        
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.5
        
        let image = #imageLiteral(resourceName: "particle_confetti")
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            cell.contents = cgImage
        }
        
        return cell
    }
    
    
    private func createEmitter() {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = CGPoint(x: frame.midX, y: frame.maxY + 96)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: frame.width, height: 1)
        particleEmitter.beginTime = CACurrentMediaTime()
        particleEmitter.emitterCells = [createEmitterCell(color: .red),
                                        createEmitterCell(color: .green),
                                        createEmitterCell(color: .blue),
                                        createEmitterCell(color: .yellow),
                                        createEmitterCell(color: .cyan),
                                        createEmitterCell(color: .magenta),
                                        createEmitterCell(color: .white)]
        layer?.addSublayer(particleEmitter)
    }
    
}
