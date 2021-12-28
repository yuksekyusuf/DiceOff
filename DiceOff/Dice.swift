//
//  Dice.swift
//  DiceOff
//
//  Created by Ahmet Yusuf Yuksek on 12/26/21.
//

import Foundation

class Dice: Equatable, Identifiable, ObservableObject {
    @Published var value = 1
    @Published var changeAmount = 0.0
    
    var owner = Player.none
    let id = UUID()
    let row: Int
    let column: Int
    let neighbors: Int
    
    static func ==(lhs: Dice, rhs: Dice) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(row: Int, column: Int, neighbors: Int) {
        self.row = row
        self.column = column
        self.neighbors = neighbors
    }
    
}
