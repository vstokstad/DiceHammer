//
//  AvgDmg.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-01-20.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

class AvgDmg: ObservableObject, Identifiable {
    public var id = UUID()
    public var avgDmg: Double = 0.0
    public var d6 = 3.0
    public var d3 = 1.5
    var oneOutOfD6 = 0.1667
    func calc(attacks: Double, toHit: Double, toWound: Double, toRend: Double, damage: Double, toSave: Double) -> Double {
  
        var wounds: Double
        let hitP: Double = ((7-toHit)*oneOutOfD6)
        let woundP: Double = hitP*((7-toWound)*oneOutOfD6)
        let saveP: Double = woundP*(((toSave+toRend)*oneOutOfD6)-oneOutOfD6)
        if toSave <= 1 {
            wounds = woundP * attacks
        }
        else {
            wounds = saveP*attacks
        }
        let damageP = wounds*damage
        avgDmg = damageP
     
      
        return(avgDmg)
    }
    
    
}
