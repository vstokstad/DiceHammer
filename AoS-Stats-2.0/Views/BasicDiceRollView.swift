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
import CoreData
import Combine
import CoreHaptics
class Dice: Identifiable, ObservableObject, Comparable {
   
    @Published var hits = 0
    @Published var id = UUID()
    @Published var value = 0
    @Published var color = Color.gray
//    @Published var image = Image(systemName: "0.square")
	@Published var diceToSave: Int
    private var d6 = {() -> Int in Int.random(in: 1...6)}
//	Sorting
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
//        self.image = Image(systemName: "\(value).square")
	
		func hitCalc2() -> Int {
			if self.value > self.diceToSave {
				self.hits += 1
			}
			return hits
		}
        return
    }
     
 
  
    
}
struct BasicDiceRollView: View {
    @Environment(\.managedObjectContext) var moc
    private var red = Color.red
    private var green = Color.green
	@State private var numberOfDice = 5.0
    @State private var diceToSave = 4
	@State private var hitRolls: [Dice] = [Dice]()
	@State private var hits = 0
	private var diceRange = 0.0...100.0
    
	
	func hitCalc() {
		var hits = 0
		for dice in hitRolls {
			if dice.value >= self.diceToSave {
			hits += 1
		}
		self.hits = hits
		}
	
		
    }

	func Roll(numberOfDice: Int, diceToSave: Int) {
// empty Roll-Array

        self.hitRolls.removeAll(keepingCapacity: false)
//        For each dice add a diceObjet
        for i in 0..<numberOfDice {
			hitRolls.insert(Dice(diceToSave: diceToSave), at: i)
			
        }
		
       hitRolls.sort()
		self.hitCalc()
    }
	
   
    
    var body: some View {
		ZStack{
			LinearGradient(Color.lightStart, Color.lightEnd)
			
				
		
			ScrollView(showsIndicators: true){
				Group{
					Text("Basic Dice Roller")
						.font(.title)
						.padding()
						
					Spacer()
					// Number of Dice
			
								
							VStack{
								HStack{
									
								
									Text("Dice: \(self.numberOfDice, specifier: "%.0f")")
									
									Spacer()
									Button("-"){
										if self.numberOfDice != 0 {
												self.numberOfDice -= 1.0
										}
									}
									.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
									.labelsHidden()
									
									Button("+"){
										if self.numberOfDice != 100 {
											self.numberOfDice += 1.0
										}
									}
									.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
									.labelsHidden()
								
								}
								ZStack{
									LinearGradient(Color.lightStart, Color.lightEnd)
										.cornerRadius(10)
										.background(LightBackground(isHighlighted: false, shape: RoundedRectangle(cornerRadius: 10)))
									Slider(value: $numberOfDice, in: diceRange, step: 1.0)
								}
							}
							.padding()
						
						
					
				}
					
				Group{
					VStack{
				
						HStack{
							ForEach(self.hitRolls, id: \.id) { dice in
//								Dice as text
							
								VStack{
									Text("\(dice.value)")
										.font(.title)
										.animation(.spring())
										.foregroundColor({()->Color in if dice.value < self.diceToSave{
												return self.red
											}
											else {
												return self.green
											}
										}())
								}
							}
							
						}
						.fixedSize(horizontal: true, vertical: false)
						Spacer()
					
						Text("Kept dice: \({()->String in for dice in self.hitRolls{self.hits += dice.hits};return self.hits.description}())")
						.font(.headline)
						
						
					}
					
							
							
							
			}
 //                    Picker för att välja vilka slag som ska sparas
				Spacer()
			 Group{
				
				HStack{
					Text("Dice to keep \(diceToSave)+")
						Spacer()
					Button("-"){
						if self.diceToSave != 1 {
							self.diceToSave -= 1
						}
					}
					.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
					.labelsHidden()
					
					Button("+"){
						if self.diceToSave != 6 {
							self.diceToSave += 1
						}
					}
					.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
					.labelsHidden()
					
						
					
							
				}
				.padding()
			}
				Spacer()
				VStack{
					Spacer()
					Button("Roll") {
                            self.Roll(numberOfDice: Int(self.numberOfDice), diceToSave: self.diceToSave)
					}
					.buttonStyle(LightButtonStyle(shape: Circle()))
					.animation(nil)
				.padding()
				}
		
			}
		
				
		}
		.edgesIgnoringSafeArea(.all)
		
	}
	
}
	
    


struct BasicDiceRollView_Previews: PreviewProvider {
  
    static var previews: some View {
       BasicDiceRollView()
        
    }
}
