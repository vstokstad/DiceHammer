//
//  CombineProfileView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-26.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI
import Combine
import CoreData
import Foundation


struct CombineProfileView: View {
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
	@State private var unitSelect = 0
	@State private var weaponSelect = 0
	
	
	
	
	var body: some View {
		NavigationView {
			VStack{
				Picker(selection: $unitSelect, label: Text(units[unitSelect].name ?? "Select unit")) {
					ForEach(self.units, id: \.id) { unit in
						Text("\(unit.name ?? "No saved units")")
						
					}
				}
				
				Picker(selection: $weaponSelect, label: Text(weapons[weaponSelect].name ?? "Select weapon")) {
					ForEach(self.weapons, id: \.id) { weapon in
						Text("\(weapon.name ?? "No Saved weapons")")
					}
				}
				
				
				
				
				
				Group{
					Text("Attacks: \(weapons[weaponSelect].attacks, specifier: "%.0f")")
					Text("To Hit: \(weapons[weaponSelect].toHit)")
					Text("To Wound: \(weapons[weaponSelect].toWound)")
					Text("Rend: \(weapons[weaponSelect].toRend)")
					Text("Save: \(weapons[weaponSelect].toSave)")
					Text("Damage: \(weapons[weaponSelect].damage)")
				}
				
				Button("Save Profile")
				{
					let unit = self.units[self.unitSelect]
					let weapon = self.weapons[self.weaponSelect]
					weapon.toUnit? = unit
					unit.addToToWeapon(weapon)
					unit.totalAvgDmg +=  weapon.avgDmg
					try? self.moc.save()
					self.presentationMode.wrappedValue.dismiss()
				}
				.font(.headline)
			}
				
			.navigationBarTitle("Combine profiles")
			.navigationBarItems(trailing: Button("Back") {
				self.presentationMode.wrappedValue.dismiss()
			})
		}
	}
}
struct CombineProfileView_Previews: PreviewProvider {
	static var previews: some View {
		CombineProfileView().environment(\.managedObjectContext, CombineProfileView().moc)
	}
}

