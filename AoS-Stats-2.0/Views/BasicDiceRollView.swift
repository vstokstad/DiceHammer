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
import UIKit
import CoreMotion
//import MultipeerConnectivity




class Dice: Identifiable, ObservableObject, Comparable {
	
	@Published var hits = 0
	@Published var id = UUID()
	@Published var value = 0
	@Published var color = Color.gray
	//    @Published var image = Image(systemName: "0.square")
	@Published var diceToSave: Int
	private var d6 = {() -> Int in Int.random(in: 1...6)}
	
	//	 haptics test
	
	
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
	@State private var rerolls = [false, false, false, false]
	private var d6 = {() -> Int in Int.random(in: 1...6)}
	@State private var rerollCount = 0
	//	Haptic feedback
	public var motionManager = CMMotionManager()
	
	public func DiceShake() {
		let feedbackGenerator = UIImpactFeedbackGenerator()
		feedbackGenerator.prepare()
		feedbackGenerator.impactOccurred()
		
	}
	func hitCalc() {
		var hits = 0
		for dice in hitRolls {
			if dice.value >= self.diceToSave {
				hits += 1
			}
			self.hits = hits
		}
		
		
	}
	func ReRolls() {
		for dice in self.hitRolls {
			//			rr ones
			if rerolls[0] == true && dice.value == 1{
				dice.value = d6()
				self.DiceShake()
				
				self.rerollCount += 1
			}
				//			rr all
			else if rerolls[1] == true {
				dice.value = d6()
				
				self.DiceShake()
				self.rerollCount += 1
			}
				//				rr failed
			else if rerolls[2] == true {
				if dice.value < self.diceToSave {
					dice.value = d6()
					
					self.DiceShake()
					self.rerollCount += 1
				}
			}
			else if rerolls[3] && dice.value == 6 {
				dice.value = d6()
				
				self.DiceShake()
				self.rerollCount += 1
			}
		}
		DiceValues()
		self.hitCalc()
	}
	
	
	func Roll(numberOfDice: Int, diceToSave: Int) {
		// empty Roll-Array
		self.rerollCount = 0
		self.DiceShake()
		self.hitRolls.removeAll(keepingCapacity: false)
		//        For each dice add a diceObjet
		for i in 0..<numberOfDice {
			hitRolls.insert(Dice(diceToSave: diceToSave), at: i)
			
			
		}
		
		hitRolls.sort()
		DiceValues()
		self.hitCalc()
	}
	
	//	DiceArrays. Maybe unnescesary?
	@State private var ones = [Int]()
	@State private var twos = [Int]()
	@State private var threes = [Int]()
	@State private var fours = [Int]()
	@State private var fives = [Int]()
	@State private var sixes = [Int]()
	func DiceValues() {
		ones.removeAll(keepingCapacity: true)
		twos.removeAll(keepingCapacity: true)
		threes.removeAll(keepingCapacity: true)
		fours.removeAll(keepingCapacity: true)
		fives.removeAll(keepingCapacity: true)
		sixes.removeAll(keepingCapacity: true)
		for i in 0..<hitRolls.count {
			let value = self.hitRolls[(i)].value
			if self.hitRolls[i].value == 1 {
				ones.append(value)
				
			}
			if self.hitRolls[i].value == 2 {
				twos.append(value)
			}
			if self.hitRolls[i].value == 3 {
				threes.append(value)
			}
			if self.hitRolls[i].value == 4 {
				fours.append(value)
			}
			if self.hitRolls[i].value == 5 {
				fives.append(value)
			}
			if self.hitRolls[i].value == 6 {
				sixes.append(value)
			}
		}
	}
	
	var body: some View {
		
		ZStack{
			LinearGradient(Color.lightStart, Color.lightEnd)
				.edgesIgnoringSafeArea(.all)
			ScrollView(showsIndicators: true){
				
				
//				Header & Dice
				Group{
					HStack{
					Text("Basic Dice Roller")
						.font(.title)
						.padding()
						Spacer()
					}
		
					
					// Number of Dice
					VStack{
						HStack{
							
							
							Text("Dice: \(self.numberOfDice, specifier: "%.0f")")
								.padding(.trailing)
							
							Button("-"){
								if self.numberOfDice != 0 {
									self.numberOfDice -= 1.0
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							
							Button("+"){
								if self.numberOfDice != 100 {
									self.numberOfDice += 1.0
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							
						}
						
							Slider(value: $numberOfDice, in: diceRange, step: 1.0)
							
						
					}
				.padding()
					
					
					
				}
//				DiceImages in VStacks
				Group{
					HStack{
						//								Diceimages
						VStack{
							ForEach(ones, id: \.self) { one in
								VStack{
									Image("dice\(one)")
										.resizable()
										.frame(width: 30, height: 30, alignment: .top)
										.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
										.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
									
								}
								
							}
							Spacer()
							if ones.count > 0 {
							Text("Ones: \(ones.count)")
								.font(.caption)
							}
						}
						VStack{
							ForEach(twos, id: \.self) { two in
								VStack{
									Image("dice\(two)")
										.resizable()
										.frame(width: 30, height: 30, alignment: .top)
										.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
										.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
								}
							}
							Spacer()
							if twos.count > 0 {
							Text("twos: \(twos.count)")
							.font(.caption)
							}
						}
						VStack{
							ForEach(threes, id: \.self) { three in
								VStack{
									Image("dice\(three)")
										.resizable()
										.frame(width: 30, height: 30, alignment: .top)
										.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
										.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
								}
							}
							Spacer()
							if threes.count > 0 {
							Text("threes: \(threes.count)")
								.font(.caption)
							}
						}
						VStack{
							ForEach(fours, id: \.self) { one in
								VStack{
									Image("dice\(one)")
										.resizable()
										.frame(width: 30, height: 30, alignment: .top)
										.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
										.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
								}
							}
							Spacer()
							if fours.count > 0 {
							Text("fours: \(fours.count)")
								.font(.caption)
								
							}
						}
						VStack{
							ForEach(fives, id: \.self) { one in
								VStack{
									Image("dice\(one)")
										.resizable()
										.frame(width: 30, height: 30, alignment: .top)
										.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
										.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
								}
							}
							Spacer()
							if fives.count > 0 {
							Text("fives: \(fives.count)")
								.font(.caption)
							}
						}
						VStack{
							ForEach(sixes, id: \.self) { one in
								VStack{
									Image("dice\(one)")
										.resizable()
										.frame(width: 30, height: 30, alignment: .top)
										.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
										.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
								}
							}
							Spacer()
							if sixes.count > 0 {
							Text("sixes: \(sixes.count)")
								.font(.caption)
							}
						}
					}
				
					.padding()
				}
			
				
//				diceStats
				Group{
					VStack{
						Text("Successful: \(self.hits)")
							.font(.subheadline)
							
						HStack{
							Text("Failed: \(self.hitRolls.count-self.hits)")
								.font(.caption)
								.padding()
							Text("Rerolls: \(self.rerollCount)")
								.font(.caption)
								.padding()
						}
					}
				}
				Divider()
//        		Rerolls
				Group{
					VStack{
						Text("Rerolls")
							.font(.subheadline)
					HStack{
						Button("1s"){
							self.rerolls[0] = true
							self.ReRolls()
							self.hitCalc()
							self.rerolls[0] = false
							
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
						.font(.caption)
						
						Button("6s"){
							self.rerolls[3] = true
							self.ReRolls()
							self.hitCalc()
							self.rerolls[3] = false
							
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
						.font(.caption)
						Button("Failed"){
							self.rerolls[2] = true
							self.ReRolls()
							self.hitCalc()
							self.rerolls[2] = false
							
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
						.font(.caption)
						
						Button("All"){
							self.rerolls[1] = true
							self.ReRolls()
							self.hitCalc()
							self.rerolls[1] = false
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
						.font(.caption)
						
					}
					.padding()
					}
				}
				
//				Dice to keep och Rolls
				Group{
					HStack{
						Text("Dice to keep: \(diceToSave)+")
							.font(.subheadline)
							.padding(.trailing)
						Button("-"){
							if self.diceToSave != 1 {
								self.diceToSave -= 1
								self.hitCalc()
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
					
						
						Button("+"){
							if self.diceToSave != 6 {
								self.diceToSave += 1
								self.hitCalc()
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
					
						
						
						
						
					}
					.padding()
				
					HStack{
					Button("Roll") {
						self.Roll(numberOfDice: Int(self.numberOfDice), diceToSave: self.diceToSave)
					}
					.buttonStyle(LightButtonStyle(shape: Circle()))
					.animation(.spring())
					.padding()
					if self.hits > 0 {
					Button("Roll kept dice") {
						self.Roll(numberOfDice: Int(self.hits), diceToSave: self.diceToSave)
						
					}
					.buttonStyle(LightButtonStyle(shape: Circle()))
					.animation(.spring())
					.padding()
					.font(.caption)
					.multilineTextAlignment(.center)
					.disabled(self.hits==0)
					}
				}
				}
				
			}
			
			
			
		}
		
	}
	
}




struct BasicDiceRollView_Previews: PreviewProvider {
	
	static var previews: some View {
		BasicDiceRollView()
		
	}
}
