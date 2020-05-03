//
//  ContentView.swift
//  NeoMorph
//
//  Created by Vilhelm Stokstad on 2020-02-28.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI


extension LinearGradient {
	init(_ colors: Color...) {
		self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
	}
}

extension Color {
	static let offWhite = Color(red: 240 / 255, green: 240 / 255, blue: 255 / 255)
	static let lightStart = Color(red: 250 / 255, green: 250 / 255, blue: 255 / 255)
	static let lightEnd = Color(red: 230 / 255, green: 230 / 255, blue: 245 / 255)
	static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
	static let darkEnd = Color(red: 25 / 255, green: 20 / 255, blue: 30 / 255)
	
}

struct LightButtonStyle<S: Shape>: ButtonStyle {
	var shape: S
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
		.padding(30)
		.contentShape(shape)
		.background(
			LightBackground(isHighlighted: configuration.isPressed, shape: shape)
		
		)
			.animation(.interactiveSpring())
	}
}


struct LightBackground<S: Shape>: View {
	var isHighlighted: Bool
	var shape: S
	
	var body: some View {
		ZStack {
			if isHighlighted {
				shape
					.fill(LinearGradient(Color.lightEnd, Color.lightStart))
					.overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4).blur(radius: 0.3).rotation3DEffect(.init(degrees: 0), axis: (x: 0, y: 4, z: 2)))
					.shadow(color: Color.lightStart, radius: 10, x: 10, y: 10)
					.shadow(color: Color.lightEnd, radius: 10, x: -10, y: -10)
	
			}
			else {
				shape
					.fill(LinearGradient(Color.lightStart, Color.lightEnd))
					.overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 2))
					.shadow(color: Color.lightEnd, radius: 10, x: 10, y: 10)
					.shadow(color: Color.lightStart, radius: 10, x: -10, y: -10)

			}
		}
	}
}


struct ContentView: View {
	@State private var isPressed = false
	

	
    var body: some View {
		
	
		ZStack{
			LinearGradient(Color.lightStart, Color.lightEnd)
			VStack{
				Spacer()
				Button("Rectangle"){
						self.isPressed.toggle()
				}
				.buttonStyle(LightButtonStyle(shape: Rectangle()))
				
				Spacer()
				Button("Circle"){
					self.isPressed.toggle()
				}
			.buttonStyle(LightButtonStyle(shape: Circle()))
				
				Spacer()
				Button("Rounded \nRectangle"){
					self.isPressed.toggle()
				}
				.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
			Spacer()
			
			}
		}
		.edgesIgnoringSafeArea(.all)
    }
	
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
