//
//  BasicDiceRollView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-21.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CoreHaptics
import UIKit


struct diceShake: GeometryEffect {
	var position: CGFloat = 0
	var animatableData: CGFloat {
		get { position }
		set { position = newValue }
	}
	func effectValue(size: CGSize) -> ProjectionTransform {
		
		return ProjectionTransform(CGAffineTransform(translationX: CGFloat(Double.random(in: -20...20)) * sin(position * 2 * .pi), y: CGFloat(Double.random(in: -20...20)) * sin(position * 2 * .pi)))
		
	}
}


struct BasicDiceRollView: View {
	@Environment(\.managedObjectContext) var moc
	@EnvironmentObject var dice: Dice
	var diceSize = Dice.diceSize
	
	
	
	let d6 = {()->Int in return Int.random(in: 1..<7)}
	
	

	@State private var numberOfDice = 5.0
	@State private var diceToSave = 4
	@State private var hitRolls: [Dice] = [Dice]()
	@State private var hits = 0
	private let diceRange = 0.0...100.0
	@State private var rerolls = [false, false, false, false]
	@State private var rerollCount = 0
	
	//	DiceArrays and sorting for viewing in columns
	@State private var ones: [Dice] = [Dice]()
	@State private var twos: [Dice] = [Dice]()
	@State private var threes: [Dice] = [Dice]()
	@State private var fours: [Dice] = [Dice]()
	@State private var fives: [Dice] = [Dice]()
	@State private var sixes: [Dice] = [Dice]()
	
	//	Haptic feedback
	@State var diceSelected = false
	public func DiceHaptic() {
		let feedbackGenerator = UIImpactFeedbackGenerator()
		if diceSelected == true {
		feedbackGenerator.prepare()
		feedbackGenerator.impactOccurred()
		}
	}
	
	//	Hits counter
	func hitCalc() {
		var hits = 0
		for dice in self.hitRolls {
			if dice.value >= self.diceToSave {
				hits += 1
			}
			self.hits = hits
		}
		
		
	}
	
	//	Rerolls
	func ReRolls() {
		for dice in self.hitRolls {
			//			rr ones
			if rerolls[0] == true && dice.value == 1{
				dice.value = d6()
			
					DiceValues()
				self.rerollCount += 1
			}
				//			rr all
			else if rerolls[1] == true {
				dice.value = d6()
					DiceValues()
			
				self.rerollCount += 1
			}
				//				rr failed
			else if rerolls[2] == true {
				if dice.value < self.diceToSave {
					dice.value = d6()
						DiceValues()
					
					self.rerollCount += 1
				}
			}
			else if rerolls[3] && dice.value == 6 {
				dice.value = d6()
					DiceValues()
			
				self.rerollCount += 1
			}
		}
		DiceValues()
		self.hitCalc()
	}
	
	//	Sorting dice into arrays for columns
	func DiceValues() {
		ones.removeAll(keepingCapacity: false)
		twos.removeAll(keepingCapacity: false)
		threes.removeAll(keepingCapacity: false)
		fours.removeAll(keepingCapacity: false)
		fives.removeAll(keepingCapacity: false)
		sixes.removeAll(keepingCapacity: false)
		for dice in hitRolls {
			
			if dice.value == 1 {
				ones.append(dice)
			}
			if dice.value == 2 {
				twos.append(dice)
			}
			if dice.value == 3 {
				threes.append(dice)
			}
			if dice.value == 4 {
				fours.append(dice)
			}
			if dice.value == 5 {
				fives.append(dice)
			}
			if dice.value == 6 {
				sixes.append(dice)
			}
		}
	}
	
	
	var body: some View {
		
		ZStack{
			LinearGradient(Color.lightStart, Color.lightEnd)
				.edgesIgnoringSafeArea(.all)
			VStack{
				HStack{
					Text("Basic Dice Roller")
						.font(.title)
						.padding(.horizontal, 10)
					Spacer()
				}
				
				
				ScrollView(showsIndicators: true){
					
					
					//				Header & Dice
					Group{
						
						// Number of Dice
						VStack{
							Spacer()
							HStack{
								
								Text("Dice: \(self.numberOfDice, specifier: "%.0f")")
									.padding(.trailing)
								
								Button("-"){
									if self.numberOfDice != 0 {
										self.numberOfDice -= 1.0
									}
								}
								.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
								.animation(nil)
								
								Button("+"){
									if self.numberOfDice != 100 {
										self.numberOfDice += 1.0
									}
								}
								.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.animation(nil)
								
							}
							
							Slider(value: $numberOfDice, in: diceRange, step: 1.0)
							
							
						}
						.padding()
						
						
						
					}
					//					DynamiDiceView
					HStack(alignment: .top, spacing: 2, content: {
						VStack{
							if ones.count != 0 {
								Text("\(ones.count)").font(.caption)
							ForEach(ones, id: \.id){ dice in
								DynamicDice(value: dice.value, diceSelected: self.diceSelected).dynamicDice(value: dice.value)	.onAppear(){	self.diceSelected.toggle()}
							}
						}
						}
						VStack{
							if twos.count != 0 {
								Text("\(twos.count)").font(.caption)
								ForEach(twos, id: \.id){ dice in
									DynamicDice(value: dice.value, diceSelected: self.diceSelected).dynamicDice(value: dice.value)	.onAppear(){	self.diceSelected.toggle()}
							}
							}
							
						}
						VStack{
							if threes.count != 0 {
								Text("\(threes.count)").font(.caption)
							ForEach(threes, id: \.id){ dice in
								DynamicDice(value: dice.value, diceSelected: self.$diceSelected.wrappedValue).dynamicDice(value: dice.value)	.onAppear(){	self.diceSelected.toggle()}
							}
							}
							
						}
						VStack{
							if fours.count != 0 {
								Text("\(fours.count)").font(.caption)
							ForEach(fours, id: \.id){ dice in
								DynamicDice(value: dice.value, diceSelected: self.$diceSelected.wrappedValue).dynamicDice(value: dice.value)	.onAppear(){	self.diceSelected.toggle()}
							}
						}
						}
						VStack{
							if fives.count != 0 {
								ZStack{
									
									Text("\(fives.count)").font(.caption)
								}
						ForEach(fives, id: \.id){ dice in
							DynamicDice(value: dice.value, diceSelected: self.$diceSelected.wrappedValue).dynamicDice(value: dice.value)	.onAppear(){	self.diceSelected.toggle()}
							
						}
						}
						}
						VStack{
							if sixes.count != 0 {
								Text("\(sixes.count)").font(.caption)
						ForEach(sixes, id: \.id){ dice in
							DynamicDice(value: dice.value, diceSelected: self.$diceSelected.wrappedValue).dynamicDice(value: dice.value)
								.onAppear(){	self.diceSelected.toggle()}
								
								.foregroundColor(.black)
							
						}
						}
						}
					})
						.onAppear(){
							self.DiceHaptic()
								
							
					}
						.onTapGesture {
							self.DiceHaptic()
							
							
						}
					
				}
				
				VStack{
					//				diceStats
					if !hitRolls.isEmpty {
						Group{
							HStack{
								Text("Failed: \(self.hitRolls.count-self.hits)")
									.font(.caption)
									.padding()
								Text("Successful: \(self.hits)")
									.font(.subheadline)
								Text("Rerolls: \(self.rerollCount)")
									.font(.caption)
									.padding()
							}
							
						}
					}
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
									self.DiceValues()
									self.rerolls[0] = false
									
								}
								.buttonStyle(LightButtonStyle(shape: Circle()))
								.font(.caption)
								
								Button("6s"){
									self.rerolls[3] = true
									self.ReRolls()
									self.hitCalc()
									self.DiceValues()
									self.rerolls[3] = false
									
								}
								.buttonStyle(LightButtonStyle(shape: Circle()))
								.font(.caption)
								Button("Failed"){
									self.rerolls[2] = true
									self.ReRolls()
									self.hitCalc()
									self.DiceValues()
									self.rerolls[2] = false
									
								}
								.buttonStyle(LightButtonStyle(shape: Circle()))
								.font(.caption)
								
								Button("All"){
									self.rerolls[1] = true
									self.ReRolls()
									self.hitCalc()
									self.DiceValues()
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
						
					}
					
					
					Spacer()
					HStack{
						Button("Roll") {
							self.hitRolls.removeAll(keepingCapacity: false)
							
							
							for _ in 0..<Int(self.numberOfDice) {
								self.hitRolls.append(Dice())
								
									self.diceSelected.toggle()
							}
							self.DiceValues()
						
							self.hitCalc()
						
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
						.padding()
						if self.hits > 0 {
							Button("Roll kept dice") {
								self.hitRolls.removeAll(keepingCapacity: false)
								
								
								for _ in 0..<self.hits {
									self.hitRolls.append(Dice())
									
										self.diceSelected.toggle()
								}
								
								self.DiceValues()
								self.hitCalc()
							}
							.buttonStyle(LightButtonStyle(shape: Circle()))
							.padding()
							.font(.caption)
							.multilineTextAlignment(.center)
							.disabled(self.hits==0)
						}
					}}.offset(x: 0, y: 0).frame(width: UIScreen.main.bounds.width).background(LightBackground(isHighlighted: false, shape: RoundedRectangle(cornerRadius: 10.0))).edgesIgnoringSafeArea(.bottom)
				
				
				
			}
			
		}
		
	}
	
}


struct BasicDiceRollView_Previews: PreviewProvider {
	
	static var previews: some View {
		BasicDiceRollView().environmentObject(Dice())
		
	}
}



