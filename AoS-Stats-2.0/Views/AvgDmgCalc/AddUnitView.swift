//
//  AddUnitView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-03-05.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation
import GameKit
import UIKit


struct AddUnitView: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.presentationMode) var presentationMode
	@FetchRequest(entity: Weapon.entity(), sortDescriptors: []) var weapons: FetchedResults<Weapon>
	@FetchRequest(entity: Unit.entity(), sortDescriptors: []) var units: FetchedResults<Unit>
	
	func deleteUnit(at offsets: IndexSet) {
		for offset in offsets {
			let unit = units[offset]
			moc.delete(unit)
		}
		
		try? moc.save()
	}
	
	@State private var combinedName = ""
	@State private var unitName = ""
	@State private var unitSelect = 0
	@State private var weaponSelect = 1
	@State private var weaponArray: [Weapon] = [Weapon]()
	@State private var unitSize: CGFloat = 1.0
	
	var body: some View {
		NavigationView{
			ZStack{
				LinearGradient(Color.lightStart, Color.lightEnd)
					.edgesIgnoringSafeArea(.all)
				VStack{
					TextField("Unit Name", text: $unitName)
						.textFieldStyle(RoundedBorderTextFieldStyle())
					
					HStack{
						Text("Unit Size: \(unitSize, specifier: "%.0f")")
							.font(.caption)
							.padding()
						Button("-"){
							if self.unitSize != 0.0 {
								self.unitSize -= 1.0
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10.0)))
						
						Button("+"){
							if self.unitSize != 60.0 {
								self.unitSize += 1.0
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
						
					}
					Slider(value: $unitSize, in: 0.0...60.0, step: 1.0)
					
					//					Picker(selection: $weaponSelect, label: Text(weapons[weaponSelect].name ?? "Select weapon")){
					//						ForEach(self.weapons, id: \.id) { weapon in
					//							Text("\(weapon.name ?? "No saved profiles")")
					//
					//						}
					//					}
					//					Text("Total Avg Dmg: \((self.weapons[self.weaponSelect].avgDmg) * Double(self.unitSize), specifier: "%.2f")")
					Button("Save"){
						let unit = Unit(context: self.moc)
						unit.id = UUID()
						unit.name = self.unitName
						unit.unitSize = Int16(self.unitSize)
						unit.totalAvgDmg = 0.0
						//						unit.toWeapon?.adding(self.weapons[self.weaponSelect])
						try? self.moc.save()
						self.presentationMode.wrappedValue.dismiss()
					}
					.buttonStyle(LightButtonStyle(shape: Circle()))
					.padding()
					
				}
			.padding()
			}
			.navigationBarTitle("new unit")
			.navigationBarItems(trailing: Button("Back"){
				self.presentationMode.wrappedValue.dismiss()
			})
			
		}
	}
}

struct AddUnitView_Previews: PreviewProvider {
	static var previews: some View {
		AddUnitView()
	}
}
