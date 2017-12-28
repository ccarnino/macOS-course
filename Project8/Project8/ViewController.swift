//
//  ViewController.swift
//  Project8
//
//  Created by Claudio Carnino on 27/12/2017.
//  Copyright © 2017 Cla. All rights reserved.
//

import Cocoa
import GameplayKit


class ViewController: NSViewController {
    
    private enum Answer: Int {
        case undefined
        case wrong
        case correct
    }
    
    private var visualEffectsView: NSVisualEffectView!
    private var gridViewButtons = [NSButton]()
    private let gridSize = 10
    private let gridMargin: CGFloat = 5
    private let buttonSize = CGSize(width: 64, height: 64)
    private var images = [#imageLiteral(resourceName: "elephant"), #imageLiteral(resourceName: "giraffe"), #imageLiteral(resourceName: "hippo"), #imageLiteral(resourceName: "monkey"), #imageLiteral(resourceName: "panda"), #imageLiteral(resourceName: "parrot"), #imageLiteral(resourceName: "penguin"), #imageLiteral(resourceName: "pig"), #imageLiteral(resourceName: "rabbit"), #imageLiteral(resourceName: "snake")]
    private var currentLevel = 1
    private let levelItemsCount = [0, 5, 15, 25, 35, 49, 65, 81, 100]
    private var gameOverView: GameOverView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLevel()
    }
    
    
    override func loadView() {
        super.loadView()
        
        visualEffectsView = NSVisualEffectView()
        visualEffectsView.material = .dark
        visualEffectsView.state = .active
        
        visualEffectsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualEffectsView)
        
        visualEffectsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let titleLabel = createTitleLabel()
        createGridView(relativeTo: titleLabel)
    }
    
    
    private func createTitleLabel() -> NSTextField {
        
        let titleLabel = NSTextField(labelWithString: "Odd one out")
        titleLabel.font = NSFont.systemFont(ofSize: 36, weight: .thin)
        titleLabel.textColor = .white
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        visualEffectsView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: visualEffectsView.topAnchor, constant: gridMargin)
        titleLabel.centerXAnchor.constraint(equalTo: visualEffectsView.centerXAnchor)
        
        return titleLabel
    }
    
    
    private func createButtonsMatrix() -> [[NSButton]] {
        
        var rowsButtons = [[NSButton]]()
        
        (0 ..< gridSize).forEach { _ in
            var rowButtons = [NSButton]()
            
            (0 ..< gridSize).forEach { _ in
                let button = NSButton(frame: NSRect(origin: .zero, size: buttonSize))
                button.setButtonType(.momentaryChange)
                button.imagePosition = .imageOnly
                button.focusRingType = .none
                button.isBordered = false
                
                button.target = self
                button.action = #selector(imageClicked(_:))
                
                gridViewButtons.append(button)
                rowButtons.append(button)
            }
            
            rowsButtons.append(rowButtons)
        }
        
        return rowsButtons
    }
    
    
    private func createGridView(relativeTo titleLabel: NSTextField) {
        
        let buttons = createButtonsMatrix()
        let gridView = NSGridView(views: buttons)
        
        gridView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectsView.addSubview(gridView)
        
        gridView.leadingAnchor.constraint(equalTo: visualEffectsView.leadingAnchor, constant: gridMargin).isActive = true
        gridView.trailingAnchor.constraint(equalTo: visualEffectsView.trailingAnchor, constant: -gridMargin).isActive = true
        gridView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: gridMargin).isActive = true
        gridView.bottomAnchor.constraint(equalTo: visualEffectsView.bottomAnchor, constant: -gridMargin).isActive = true
        
        gridView.columnSpacing = gridMargin / 2
        gridView.rowSpacing = gridMargin / 2
        
        (0 ..< gridSize).forEach { index in
            gridView.row(at: index).height = 64
            gridView.column(at: index).width = 64
        }
    }
    
    
    private func generateLayout(items: Int) {
        // Reset buttons
        gridViewButtons.forEach { button in
            button.tag = Answer.undefined.rawValue
            button.image = nil
        }
        
        let randomiser = GKRandomSource.sharedRandom()
        gridViewButtons = randomiser.arrayByShufflingObjects(in: gridViewButtons) as! [NSButton]
        images = randomiser.arrayByShufflingObjects(in: images) as! [NSImage]
        
        var numUsed = 0
        var itemCount = 1
        
        let firstButton = gridViewButtons.first!
        firstButton.tag = Answer.correct.rawValue
        firstButton.image = images.first!
        
        (1 ..< items).forEach { indexItem in
            let button = gridViewButtons[indexItem]
            button.tag = Answer.wrong.rawValue
            button.image = images[itemCount]
            
            numUsed += 1
            
            if numUsed == 2 {
                numUsed = 0
                itemCount += 1
            }
            
            if itemCount == images.count {
                itemCount = 1
            }
        }
    }
    
    
    private func gameOver() {
        
        gameOverView = GameOverView()
        gameOverView.alphaValue = 0
        
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameOverView)
        
        NSLayoutConstraint.activate([gameOverView.topAnchor.constraint(equalTo: view.topAnchor),
                                     gameOverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     gameOverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     gameOverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        gameOverView.layoutSubtreeIfNeeded()
        
        gameOverView.startEmitting()
        NSAnimationContext.current.duration = 1
        gameOverView.alphaValue = 1
    }
    
    
    private func createLevel() {
        guard currentLevel < 9 else {
            gameOver()
            return
        }
        generateLayout(items: levelItemsCount[currentLevel])
    }
    
    
    @objc private func imageClicked(_ sender: NSButton) {
        
        let answer = Answer(rawValue: sender.tag)
        
        switch answer {
        case .correct?:
            currentLevel += 1
            createLevel()
        default:
            break
        }
    }
    
}
