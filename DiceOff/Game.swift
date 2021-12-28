//
//  Game.swift
//  DiceOff
//
//  Created by Ahmet Yusuf Yuksek on 12/26/21.
//

import Foundation
import SwiftUI

class Game: ObservableObject {
    
    var rows: [[Dice]]
    
    
    private let numRows: Int
    private let numCols: Int
    
    @Published var activePlayer = Player.green
    @Published var state = GameState.waiting
    
    @Published var greenScore = 0
    @Published var redScore = 0
    
    var changeList = [Dice]()
    
    init(rows: Int, columns: Int) {
        numRows = rows
        numCols = columns
        self.rows = [[Dice]]()
        
        for rowCount in 0..<numRows {
            var newRow = [Dice]()
            
            for colCount in 0..<numCols {
                let dice = Dice(row: rowCount, column: colCount,
                                neighbors: countNeighbors(row: rowCount, col: colCount))
                newRow.append(dice)
            }
            self.rows.append(newRow)
        }
        
    }
    
    private func countNeighbors(row: Int, col: Int) -> Int {
        var result = 0
        
        if col > 0 { //one to the left
            result += 1
        }
        
        if col < numCols - 1 {// one to the right
            result += 1
        }
        
        if row > 0 { //one above
            result += 1
        }
        
        if row < numRows - 1 {// one below
            result += 1
        }
        
        
        return result
    }
    
    private func getNeighbors(row: Int, col: Int) -> [Dice] {
        
        var result = [Dice]()
        
        if col > 0 { //one to the left
            result.append(rows[row][col - 1])
        }
        
        if col < numCols - 1 {// one to the right
            result.append(rows[row][col + 1])
        }
        
        if row > 0 { //one above
            result.append(rows[row - 1][col])
        }
        
        if row < numRows - 1 {// one below
            result.append(rows[row + 1][col])
        }
        
        
        return result
    }
    
    private func bump(_ dice: Dice) {
        dice.value += 1
        dice.owner = activePlayer
        dice.changeAmount = 1
        
        withAnimation {
            dice.changeAmount = 0
        }
        
        if dice.value > dice.neighbors {
            dice.value = 1
            
            for neighbor in getNeighbors(row: dice.row, col: dice.column) {
                changeList.append(neighbor)
            }
        }
    }
    
    private func runChanges() {
        if changeList.isEmpty {
            nextTurn()
            return
        }
        
        
        let toChange = changeList
        changeList.removeAll()
        
        for dice in toChange {
            bump(dice)
        }
        
        greenScore = score(for: .green)
        redScore = score(for: .red)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.runChanges()
        }
    }
    
    private func nextTurn() {
        if activePlayer == .green {
            activePlayer = .red
            
        } else {
            activePlayer = .green
        }
        state = .waiting
    }
    
    func increment(_ dice: Dice) {
        guard state == .waiting else { return }
        guard dice.owner == .none || dice.owner == activePlayer else { return }
        
        state = .changing
        changeList.append(dice)
        runChanges()
    }
    
    private func score(for player: Player) -> Int {
        var count = 0
        
        for row in rows{
            for col in row {
                if col.owner == player {
                    count += 1
                }
                
            }
        }
        return count
    }
    
}
