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
class Dice: Identifiable, ObservableObject, Comparable {
   
    
    @Published var id = UUID()
    @Published var value = 1
    @Published var color = Color.gray
    @Published var image = Image(systemName: "0.square")
    @Published var diceToSave = Int()
    private var d6 = {() -> Int in Int.random(in: 1...6)}
    static func < (lhs: Dice, rhs: Dice) -> Bool {
        if lhs.value != rhs.value {
            return lhs.value < rhs.value
        }
        else {
            return lhs.value > rhs.value
        }
    }
    
    static func == (lhs: Dice, rhs: Dice) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(diceToSave: Int) {
        self.diceToSave = diceToSave
        self.value = d6()
        self.image = Image(systemName: "\(value).square")
        
        return
    }
     
 
  
    
}
struct BasicDiceRollView: View {
    @Environment(\.managedObjectContext) var moc
    private var red = Color.red
    private var green = Color.green
    @State private var numberOfDice: Double = 10.0
    @State private var diceToSave = 4
    @State var hitRolls: [Dice] = [Dice(diceToSave: 0)]
    @State private var hits: Int = 0
//    @State private var diceSlider: Double = 10.0
    private var diceRange = 1.0...100.0
    
    func hitCalc(dice: Dice) {
        if dice.value >= diceToSave {
            hits += 1
        }
        
    }

    func Roll(numberOfDice: Int, diceToSave: Int) {
//Resets values
        hits = 0
        self.hitRolls.removeAll(keepingCapacity: false)
//        For each dice add a diceObjet
        for _ in 0...numberOfDice {
            if hitRolls.isEmpty {
                hitRolls.insert(Dice(diceToSave: diceToSave), at: 0)
            }
            else {
                hitRolls.append(Dice(diceToSave: diceToSave))
            }
        }

        
       hitRolls.sort()


    }

//    func DiceSlideConvert(slideValue: CGFloat) -> Int{
//       return slideValue.exponent
//    }
  
   
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    HStack{
                        Stepper("Dice", value: $numberOfDice.animation(), in: diceRange)
                            .labelsHidden()
                        
                        Spacer()
                        Text("Number of dice: \(numberOfDice, specifier: "%.0f")")
                    }
                    
                    Slider(value: $numberOfDice, in: diceRange, step: 1.0)
                }
             
                Section{
                    
                        ForEach(self.hitRolls, id: \.id) { dice in
                            VStack{
                               
                                        dice.image
                                            .foregroundColor({ () -> Color in
                                                if dice.value < self.diceToSave {
                                                    return self.red
                                                }
                                                else {
                                                    return self.green
                                                }
                                            }())  .padding()
                              
                                
                                
                            
                            }
                            .imageScale(.large)
                        
                        
                            
                        
                        }
                     
                                       
                    
                              Text("Kept dice: \(self.hits)")
                            
                        
                }
                
                  
                
                
                
                Section{
 //                    Picker för att välja vilka slag som ska sparas
                    HStack{
                        Stepper("Dice roll to keep", value: $diceToSave.animation(), in: 1...6)
                            .labelsHidden()
                            
                          
                        Spacer()
                        Text("Dice roll to keep \(diceToSave)+")
                    }
                    HStack{
                Spacer()
                        Button("Roll Hits") {
                           
                            self.Roll(numberOfDice: Int(self.numberOfDice), diceToSave: self.diceToSave)
                          
                            
                        }
                        .font(.title)
                       
                        Spacer()
                     
                       
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
