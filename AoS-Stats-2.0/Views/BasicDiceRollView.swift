//
//  BasicDiceRollView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-21.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData
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
		
		return ProjectionTransform(CGAffineTransform(translationX: 50 * sin(position * 2 * .pi), y: CGFloat(Double.random(in: -30...30)) * sin(position * 2 * .pi)))
		
	}
}


class Dice: Identifiable, ObservableObject, Comparable {
	@Published var id = UUID()
	@Published var value = {()->Int in return Int.random(in: 1...6)}()
	@Published var one = true
	@Published var two = true
	@Published var three = true
	@Published var four = true
	@Published var five = true
	@Published var six = true
	
	static var diceSize: CGFloat = 10
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
	func roll() {
	if value == 1 {
	
	one = true
	two = false
	three = false
	four = false
	five = false
	six = false
	}
	else if value == 2 {
	
	one = false
	two = true
	three = false
	four = false
	five = false
	six = false
	}
	else if value == 3 {
	
	one = false
	two = false
	three = true
	four = false
	five = false
	six = false
	}
	else if value == 4 {
	
	one = false
	two = false
	three = false
	four = true
	five = false
	six = false
	}
	else if value == 5 {
	
	one = false
	two = false
	three = false
	four = false
	five = true
	six = false
	}
	else if value == 6 {
	
	one = false
	two = false
	three = false
	four = false
	five = false
	six = true
	
	}
	}
	init() {
		roll()
	}
	//		self.diceSelected.toggle()
}


struct BasicDiceRollView: View {
	@Environment(\.managedObjectContext) var moc
	@ObservedObject var dice: Dice
	var diceSize = Dice.diceSize

	@State public var diceSelected = false
	
	
	let d6 = {()->Int in return Int.random(in: 1..<7)}
	
	
//	func diceRoll() {
//		// empty Roll-Array
//		self.rerollCount = 0
//		//		self.DiceHaptic()
//		self.hitRolls.removeAll(keepingCapacity: true)
//
//		//        For each dice add a diceObjet
//		for _ in 0..<Int(self.numberOfDice) {
//			let dice = Dice()
//			let value = dice.value
//			var one = dice.one
//			var two = dice.two
//			var three = dice.three
//			var four = dice.four
//			var five = dice.five
//			var six = dice.six
//
//			hitRolls.append(dice)
//
//
//		//		BasicDiceRollView().DiceHaptic()
//		//		self.diceSelected.toggle()
//		if value == 1 {
//
//			one = true
//			two = false
//			three = false
//			four = false
//			five = false
//			six = false
//		}
//		else if value == 2 {
//
//			one = false
//			two = true
//			three = false
//			four = false
//			five = false
//			six = false
//		}
//		else if value == 3 {
//
//			one = false
//			two = false
//			three = true
//			four = false
//			five = false
//			six = false
//		}
//		else if value == 4 {
//
//			one = false
//			two = false
//			three = false
//			four = true
//			five = false
//			six = false
//		}
//		else if value == 5 {
//
//			one = false
//			two = false
//			three = false
//			four = false
//			five = true
//			six = false
//		}
//		else if value == 6 {
//
//			one = false
//			two = false
//			three = false
//			four = false
//			five = false
//			six = true
//
//		}
//		//		self.diceSelected.toggle()
//		}
//	}
	@State private var numberOfDice = 5.0
	@State private var diceToSave = 4
	@State private var hitRolls: [Dice] = [Dice]()
	@State private var hits = 0
	private var diceRange = 0.0...100.0
	@State private var rerolls = [false, false, false, false]
	@State private var rerollCount = 0
	
	//	Haptic feedback
	
	public func DiceHaptic() {
		let feedbackGenerator = UIImpactFeedbackGenerator()
		feedbackGenerator.prepare()
		feedbackGenerator.impactOccurred()
		
	}
	func hitCalc() {
		var hits = 0
		for dice in self.hitRolls {
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
				self.DiceHaptic()
				
				self.rerollCount += 1
			}
				//			rr all
			else if rerolls[1] == true {
				dice.value = d6()
				
				self.DiceHaptic()
				self.rerollCount += 1
			}
				//				rr failed
			else if rerolls[2] == true {
				if dice.value < self.diceToSave {
					dice.value = d6()
					
					self.DiceHaptic()
					self.rerollCount += 1
				}
			}
			else if rerolls[3] && dice.value == 6 {
				dice.value = d6()
				
				self.DiceHaptic()
				self.rerollCount += 1
			}
		}
		DiceValues()
		self.hitCalc()
	}
	
	
	
	
	//	DiceArrays.
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
			let value = self.hitRolls[i].value
			if value == 1 {
				ones.append(value)
			}
			if value == 2 {
				twos.append(value)
			}
			if value == 3 {
				threes.append(value)
			}
			if value == 4 {
				fours.append(value)
			}
			if value == 5 {
				fives.append(value)
			}
			if value == 6 {
				sixes.append(value)
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
				
				
				ScrollView(showsIndicators: false){
					
					
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
					//					DynamiDiceView
					Group{
						VStack{
							Button(action: {self.diceSelected.toggle(); self.Roll(numberOfDice: Int(self.numberOfDice), diceToSave: self.diceToSave)}) {
								
								ZStack {
									
									RoundedRectangle(cornerRadius: diceSize/2)
										.strokeBorder(lineWidth: diceSize/10, antialiased: true)
										.frame(width: diceSize * 4, height: diceSize * 4, alignment: .center)
									
									ZStack{
										//							center middledot
										if dice.one || dice.five || dice.three {
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(0), y: CGFloat(0))
											
										}
										if dice.three || dice.six || dice.five || dice.four {
											//							Bottom corner right
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(diceSize*1.1), y: CGFloat(diceSize*1.1))
										}
										if dice.five || dice.six || dice.three || dice.four {
											//							top corner left
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-diceSize*1.1), y: CGFloat(-diceSize*1.1))
										}
										if dice.six {
											//							right middle
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(diceSize*1.1), y: CGFloat(diceSize-diceSize))
										}
										if dice.six {
											//							left midde
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-diceSize*1.1), y: CGFloat(diceSize-diceSize))
										}
										if dice.five || dice.six || dice.two || dice.four {
											//							right top corner
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(diceSize*1.1), y: CGFloat(-diceSize*1.1))
										}
										if dice.five || dice.six || dice.two || dice.four {
											//							left bottom corner
											Circle()
												.frame(width: diceSize/1.2, height: diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-diceSize*1.1), y: CGFloat(diceSize*1.1))
										}
									}
									
									
									
								}
								.modifier(diceShake(position: diceSelected ? 1 : 0))
								.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
								.foregroundColor(.black)
								.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
								.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
								
								
								
								
								
							}
							
							
						}
						.onAppear(){
							
							self.diceSelected.toggle()
						}
						.onDisappear(){
							
							self.diceSelected.toggle()
						}
						
					}
					
					//				DiceImages in VStacks
					Group{
						HStack{
							//								Diceimages
							VStack{
								
								if ones.count > 0 {
									Text("ones: \(ones.count)")
										.font(.caption)
								}
								
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
							}
							VStack{
								
								if twos.count > 0 {
									Text("twos: \(twos.count)")
										.font(.caption)
								}
								
								ForEach(twos, id: \.self) { two in
									VStack{
//										DynamicDiceView(diceSelected: self.diceSelected, numberOfDice: Int(self.numberOfDice))
																			Image("dice\(two)")
																				.resizable()
																				.frame(width: 30, height: 30, alignment: .top)
																				.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
																				.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
									}
								}
								Spacer()
							}
							VStack{
								
								if threes.count > 0 {
									Text("threes: \(threes.count)")
										.font(.caption)
								}
								
								ForEach(threes, id: \.self) { three in
									VStack{
//										DynamicDiceView(diceSelected: self.diceSelected, numberOfDice: Int(self.numberOfDice))
																			Image("dice\(three)")
																				.resizable()
																				.frame(width: 30, height: 30, alignment: .top)
																				.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
																				.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
									}
								}
								Spacer()
							}
							VStack{
								
								if fours.count > 0 {
									Text("fours: \(fours.count)")
										.font(.caption)
									
								}
								
								ForEach(fours, id: \.self) { one in
									VStack{
//										DynamicDiceView(diceSelected: self.diceSelected, numberOfDice: Int(self.numberOfDice))
																			Image("dice\(one)")
																				.resizable()
																				.frame(width: 30, height: 30, alignment: .top)
																				.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
																				.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
									}
								}
								Spacer()
							}
							VStack{
								if fives.count > 0 {
									Text("fives: \(fives.count)")
										.font(.caption)
								}
								
								ForEach(fives, id: \.self) { five in
									VStack{
//										DynamicDiceView(diceSelected: self.diceSelected, numberOfDice: Int(self.numberOfDice))
										Image("dice\(five)")
											.resizable()
											.frame(width: 30, height: 30, alignment: .top)
											.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
											.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
									}
								}
								Spacer()
							}
							VStack{
								if sixes.count > 0 {
									Text("sixes: \(sixes.count)")
										.font(.caption)
								}
								
								ForEach(sixes, id: \.self) { six in
									VStack{
//										DynamicDiceView(diceSelected: self.diceSelected, numberOfDice: Int(self.numberOfDice))
										Image("dice\(six)")
											.resizable()
											.frame(width: 30, height: 30, alignment: .top)
											.shadow(color: .lightEnd, radius: 5, x: 5, y: 5)
											.shadow(color: .lightStart, radius: 5, x: -5, y: -5)
									}
								}
								
								Spacer()
							}
						}
						Spacer()
						
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
						
					}
					
					
					Spacer()
					HStack{
						Button("Roll") {
							Dice().Roll(numberOfDice: Int(self.numberOfDice), diceToSave: self.diceToSave)
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
						.padding()
						if self.hits > 0 {
							Button("Roll kept dice") {
								self.Roll(numberOfDice: Int(self.hits), diceToSave: self.diceToSave)
								
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
			BasicDiceRollView()
			
		}
}
