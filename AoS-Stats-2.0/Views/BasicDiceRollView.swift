//
//  BasicDiceRollView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-21.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import SwiftUI
import GameKit
import Combine

struct BasicDiceRollView: View {
    @Environment(\.managedObjectContext) var moc
  
    @State private var dice = 10.0
    @State public var diceToSave = 4
    @State public var hitRolls = [Int]()
    @State private var diceRange = 1...6
    @State private var hits: Int = 0
    @State private var diceSlider: Double = 3.0
    @State private var color: Color = .green
  
    func DiceToKeep(diceRoll: Int) -> Int {
        if diceRoll >= diceToSave {
            
            hits += 1
        }
        else {
            
            hits -= 1
            
        }
        return hits
    }
    func DiceImage(diceRoll: Int) -> some View {
        var diceColor: Color
    
        if diceRoll >= diceToSave {
            diceColor = .green
            color = .green
            hits += 1
        }
            else {
            diceColor = .red
            color = .red
            hits -= 1
                  
            }
        let diceImage: some View = Image(systemName: "\(diceRoll).square").foregroundColor(diceColor).imageScale(.large)
        return diceImage
    }
    func d6() -> Int
    {
        return Int.random(in: 1...6)
    }
    func Roll(dice: Int) {
       
        hits = 0
  
        self.hitRolls.removeAll(keepingCapacity: false)
     
        for _ in 0..<dice {
        let diceRoll = d6()
            if hitRolls.isEmpty {
                hitRolls.insert(diceRoll, at: 0)
                    if diceRoll >= diceToSave {
                        hits += 1
                    }
            }
            else {
                hitRolls.append(diceRoll)
                if diceRoll >= diceToSave {
                    hits += 1
                }
           
            }
         
        }
       hitRolls.sort()
//        return hitRolls
        
    }

    func DiceSlideConvert(slideValue: CGFloat) -> Int{
       return slideValue.exponent
    }
  
   
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    HStack{
                        Stepper("Dice", value: $dice, in: 1...14)
                            .labelsHidden()
                        
                        Spacer()
                        Text("Number of dice: \(dice, specifier: "%.0f")")
                    }
                    
                    Slider(value: $dice, in: 1...14, step: 1.0)
                }
             
                Section{
                   
                        if hitRolls.isEmpty {
                            Text("No Rolls")
                        }
                        else {
                            VStack{
                                ForEach(0..<Int(dice), id: \.self) { die in
                                    
                                    HStack{
//                                    ForEach(self.hitRolls, id: \.self) { roll in
//                                        Roll(dice: Int(dice))
                                        self.DiceImage(diceRoll: self.hitRolls[die])
                                    }
                                }
                                       
                                
                            }
                                      
                                
                        
                            
                                
                        
                        }
                    }
                
                  
                
                
                
                Section{
 //                    Picker för att välja vilka slag som ska sparas
                    HStack{
                        Stepper("Dice roll to keep", value: $diceToSave, in: 1...6)
                            .labelsHidden()
                          
                        Spacer()
                        Text("Dice roll to keep \(diceToSave)+")
                    }
                    HStack{
//                  HitRoll Button
                        Button("Roll Hits") {
                            self.Roll(dice: Int(self.dice))
                        }
                        Spacer()
                     
                        Text("Kept dice: \(hits)")
                    }
                }
             
                    
                   
                

               
                    
                }
            .navigationBarTitle("Basic Dice Roll")
            }
        }
    }

   
    


struct BasicDiceRollView_Previews: PreviewProvider {
    static var previews: some View {
     
      BasicDiceRollView()
    }
}
