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
	static var lightStart = Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255)
	static var lightEnd = Color(red: 200 / 255, green: 200 / 255, blue: 205 / 255)
	static let darkStart = Color(red: 50 / 255, green: 50 / 255, blue: 70 / 255)
	static let darkEnd = Color(red: 20 / 255, green: 20 / 255, blue: 20 / 255)
	
	
}


struct LightButtonStyle<S: Shape>: ButtonStyle {
	var shape: S
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.padding(15)
			.contentShape(shape)
			.background(
				LightBackground(isHighlighted: configuration.isPressed, shape: shape)
				
				
		)
			
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
					.overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4).blur(radius: 0.3))
					.overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 0.3))
					.shadow(color: Color.lightStart, radius: 8, x: 8, y: 8)
					.shadow(color: Color.lightEnd, radius: 8, x: -10, y: -10)
				
			}
			else {
				shape
					.fill(LinearGradient(Color.lightStart, Color.lightEnd))
					.overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4).blur(radius: 0.2))
					.overlay(shape.stroke(LinearGradient(Color.lightEnd, Color.lightStart), lineWidth: 0.9))
					.shadow(color: Color.lightEnd, radius: 8, x: 8, y: 8)
					.shadow(color: Color.lightStart, radius: 8, x: -8, y: -8)
				
			}
		}
	}
}

struct NeoMorphView: View {
    var body: some View {
		ZStack{
			LinearGradient.init(Color.lightStart, Color.lightEnd)
			.edgesIgnoringSafeArea(.all)
			Button("Button"){
				
			}
		.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
			.font(.caption)
		
		}
		
    }
}

struct NeoMorphView_Previews: PreviewProvider {
    static var previews: some View {
        NeoMorphView()
		
    }
}
