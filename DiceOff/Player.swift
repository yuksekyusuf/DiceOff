//
//  Player.swift
//  DiceOff
//
//  Created by Ahmet Yusuf Yuksek on 12/26/21.
//

import SwiftUI


enum Player {
    case none, green, red
    
    var color: Color {
        switch self {
        case .none:
            return Color(white: 0.6)
        case .green:
            return .green
        case .red:
            return .red
        }
        
    }
    
    
}
