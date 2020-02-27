//
//  DiceRolls.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-26.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class DiceRolls: ObservableObject, Identifiable {
    public var id = UUID()
    public var d6 = {() -> Int in Int.random(in: 1...6)}
    public var d3 = {() -> Int in Int.random(in: 1...3)}
    var oneOutOfD6 = 0.1667
    public var hitRolls: [Int] = [0]
    public var diceTypeD6 = true
    var dice: Int
  
    func calc(diceTypeD6: Bool) {
       var die: Int
        for roll in 0...dice {
            if diceTypeD6 == true{
                 die = d6()
            }
            else {
                die = d3()
            }
            hitRolls.insert(die, at: roll)
        }
        hitRolls.sort()
    }
    
    init(dice: Int, diceTypeD6: Bool) {
        self.diceTypeD6 = diceTypeD6
        self.dice = dice
        calc(diceTypeD6: diceTypeD6)
       
    }
    
}
