//
//  NeoMorphView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-29.
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
	static let lightStart = Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255)
	static let lightEnd = Color(red: 220 / 255, green: 210 / 255, blue: 215 / 255)
	static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
	static let darkEnd = Color(red: 25 / 255, green: 20 / 255, blue: 30 / 255)
	
}
extension Text {
	static let lightStart = Color.lightStart
	static let lightEnd = Color.lightEnd
	static let lightGradient = LinearGradient(lightStart, lightEnd)
}


struct LightButtonStyle<S: Shape>: ButtonStyle {
	var shape: S
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(20)
			.contentShape(shape)
			.background(
				LightBackground(isHighlighted: configuration.isPressed, shape: shape)
				
				
		)
			.animation(nil)
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
					.overlay(shape.stroke(Color.lightStart, lineWidth: 0.3))
					.shadow(color: Color.lightStart, radius: 10, x: 10, y: 10)
					.shadow(color: Color.lightEnd, radius: 10, x: -10, y: -10)
				
			}
			else {
				shape
					.fill(LinearGradient(Color.lightStart, Color.lightEnd))
					.overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 1))
					.overlay(shape.stroke(Color.lightStart, lineWidth: 0.3))
					.shadow(color: Color.lightEnd, radius: 5, x: 5, y: 5)
					.shadow(color: Color.lightStart, radius: 5, x: -5, y: -5)
				
			}
		}
	}
}
struct NeoMorphView: View {
    var body: some View {
		ZStack{
			LinearGradient.init(Color.lightStart, Color.lightEnd)
			Button(""){
				
			}
		.buttonStyle(LightButtonStyle(shape: Circle()))
		
		}
		.edgesIgnoringSafeArea(.all)
    }
}

struct NeoMorphView_Previews: PreviewProvider {
    static var previews: some View {
        NeoMorphView()
		
    }
}
