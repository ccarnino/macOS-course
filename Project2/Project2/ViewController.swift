//
//  ViewController.swift
//  Project2
//
//  Created by Claudio Carnino on 06/12/2017.
//  Copyright © 2017 Tugulab. All rights reserved.
//

import Cocoa
import GameplayKit


class ViewController: NSViewController {

    @IBOutlet var guessTextField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    private var solution: String!
    private var guesses: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }
    
    
    private func startNewGame() {
        // Clenaup
        guessTextField.stringValue = ""
        guesses = []
        
        // Generate a new guess
        let numbers = Array(0...9)
        guard let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numbers) as? [Int] else { return }
        
        solution = shuffledNumbers.dropLast(6)
            .map { String($0) }
            .joined()
    }
    
    
    @IBAction func guess(_ sender: Any) {
        
        let guess = guessTextField.stringValue
        guard guess.count == solution.count
            else {
                return
        }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        guesses.insert(guess, at: 0)
        tableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)
        
        guard let result = self.result(for: guess) else { return }
        if result.bulls == solution.count {
            // Win
            let alert = NSAlert()
            alert.messageText = "You win"
            alert.informativeText = "Ok to play again"
            alert.runModal()
            
            startNewGame()
        }
    }
    
    
    private func result(for guess: String) -> (bulls: Int, cows: Int)? {
        
        let digitsInSolution = solution.count
        guard guess.count == digitsInSolution else {
            assertionFailure()
            return nil
        }
        
        var bullsCount = 0
        var cowsCount = 0
        
        let solutionCharacters = Array(solution)
        let guessCharacters = Array(guess)
        
        for index in 0 ..< digitsInSolution {
            
            if guessCharacters[index] == solutionCharacters[index] {
                bullsCount += 1
            
            } else if solution.contains(guessCharacters[index]) {
                cowsCount += 1
            }
        }
        
        return (bulls: bullsCount, cows: cowsCount)
    }
    
}


extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return guesses.count
    }
    
}


extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn,
            let cellView = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? NSTableCellView
            else {
                return nil
        }
        
        // This is extremely hackish and I am ashemed of writing this, but that's what course forces me to do...
        let isGuessColumn = tableColumn.title == "Guess"
        if isGuessColumn {
            cellView.textField?.stringValue = guesses[row]
        
        } else if let result = self.result(for: guesses[row]) {
            cellView.textField?.stringValue = "\(result.bulls)b \(result.cows)c"
        
        } else {
            cellView.textField?.stringValue = "Error"
        }
        
        return cellView
    }
    
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
}
