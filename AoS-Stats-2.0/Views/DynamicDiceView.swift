//
//  DynamicDiceView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-03-16.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
class DynamicDice: ObservableObject {
	@State private var diceSelected: Bool
	var value = 0
	var diceSize: CGFloat = Dice.diceSize
	func dynamicDice(value: Int) -> some View {
		var dice: some View {
			
			
			VStack{
				if value == 1 {
					ZStack {
						RoundedRectangle(cornerRadius: self.diceSize/2)
							.strokeBorder(lineWidth: self.diceSize/10, antialiased: true)
							.frame(width: self.diceSize * 4, height: self.diceSize * 4, alignment: .center)
						ZStack{
							//							center middledot
							Circle()
								.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
								.offset(x: CGFloat(0), y: CGFloat(0))
							
						}
						.modifier(diceShake(position: self.diceSelected ? 1 : 0))
						.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
						.foregroundColor(.black)
					}
				}
				else if value == 2 {
					ZStack {
						RoundedRectangle(cornerRadius: self.diceSize/2)
							.strokeBorder(lineWidth: self.diceSize/10, antialiased: true)
							.frame(width: self.diceSize * 4, height: self.diceSize * 4, alignment: .center)
						ZStack{
							//							right top corner
							Circle()
								.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
								.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
							
							
							//							left bottom corner
							Circle()
								.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
								.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
							
						}
						
						
						
					}
					.modifier(diceShake(position: self.diceSelected ? 1 : 0))
					.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
					.foregroundColor(.black)
					.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
					.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
				}
				else if value == 3 {
								ZStack {
									
									RoundedRectangle(cornerRadius: CGFloat(self.diceSize/2))
										.strokeBorder(lineWidth: self.diceSize/10, antialiased: true)
										.frame(width: self.diceSize * 4, height: self.diceSize * 4, alignment: .center)
									
									ZStack{
										//		center middledot
										
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(0), y: CGFloat(0))
											
										
							
											//							Bottom corner right
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
										
									
											//							top corner left
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
									}
								}
								.modifier(diceShake(position: self.diceSelected ? 1 : 0))
								.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
								.foregroundColor(.black)
								.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
								.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
							}
				else if value == 4 {
								ZStack {
									RoundedRectangle(cornerRadius: self.diceSize/2)
										.strokeBorder(lineWidth: self.diceSize/10, antialiased: true)
										.frame(width: self.diceSize * 4, height: self.diceSize * 4, alignment: .center)

								ZStack{
							
										//							Bottom corner right
										Circle()
											.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
											.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
									
										//							top corner left
										Circle()
											.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
											.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
									
										//							right top corner
										Circle()
											.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
											.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
									
										//							left bottom corner
										Circle()
											.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
											.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
									
								}
								}
								.modifier(diceShake(position: self.diceSelected ? 1 : 0))
								.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
								.foregroundColor(.black)
								.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
								.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
							}
				else if value == 5 {
								ZStack {
									RoundedRectangle(cornerRadius: self.diceSize/2)
										.strokeBorder(lineWidth: self.diceSize/10, antialiased: true)
										.frame(width: self.diceSize * 4, height: self.diceSize * 4, alignment: .center)
									ZStack{
										//							center middledot
									
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(0), y: CGFloat(0))
											
										
											//							Bottom corner right
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
									
											//							top corner left
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
										
											//							right top corner
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
									
											//							left bottom corner
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
										
									}
									
									
									
								}
								.modifier(diceShake(position: self.diceSelected ? 1 : 0))
								.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
								.foregroundColor(.black)
								.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
								.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
							}
				else if value == 6 {
								ZStack {
									
									RoundedRectangle(cornerRadius: self.diceSize/2)
										.strokeBorder(lineWidth: self.diceSize/10, antialiased: true)
										.frame(width: self.diceSize * 4, height: self.diceSize * 4, alignment: .center)
									
									ZStack{
									
									
											//							Bottom corner right
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
										
									
											//							top corner left
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
										
											//							right middle
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(self.diceSize-self.diceSize))
									
											//							left midde
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(self.diceSize-self.diceSize))
										
											//							right top corner
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(self.diceSize*1.1), y: CGFloat(-self.diceSize*1.1))
									
											//							left bottom corner
											Circle()
												.frame(width: self.diceSize/1.2, height: self.diceSize/1.2, alignment: .center)
												.offset(x: CGFloat(-self.diceSize*1.1), y: CGFloat(self.diceSize*1.1))
										
									}
									
									
									
								}
								.modifier(diceShake(position: self.diceSelected ? 1 : 0))
								.animation(Animation.default.repeatCount(Int.random(in: 1...10)).speed(Double(Int.random(in: 3...10))))
								.foregroundColor(.black)
								.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
								.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
							}
							
			}
		}
	return dice
	}
	init(value: Int, diceSelected: Bool) {
		self.value = value
		self.diceSelected = diceSelected
	}
}
