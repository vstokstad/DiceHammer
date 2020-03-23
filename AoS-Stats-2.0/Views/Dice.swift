//
//  Dice.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-03-16.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class Dice: Identifiable, ObservableObject, Comparable {
	@Published var id = UUID()
	@Published var value: Int
	@Published var one = true
	@Published var two = true
	@Published var three = true
	@Published var four = true
	@Published var five = true
	@Published var six = true
	
	static var diceSize: CGFloat = 10
	var d6 = {()->Int in return Int.random(in: 1..<7)}
	
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
	func roll(value: Int) {
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
		self.value = d6()
		self.roll(value: self.value)
	}
}
