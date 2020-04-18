//
//  AddProfileView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-20.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI
import CoreData
import UIKit
import GameKit

struct AddWeaponView: View {
	
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
	
	@FetchRequest(entity: Weapon.entity(), sortDescriptors: []) var weapons: FetchedResults<Weapon>
	@FetchRequest(entity: Unit.entity(), sortDescriptors: []) var units: FetchedResults<Unit>

    @State private var name = ""
	@State private var editMode = false
	@State var attacks: Double
	@State var toHit: Int
	@State var toWound: Int
	@State var toRend: Int
	@State var toSave: Int
	@State var damage: Int
	@State private var unitSelect = 0
	var avgDmg = AvgDmg()

    
    var body: some View {
		NavigationView{
			ZStack{
				LinearGradient(Color.lightStart, Color.lightEnd)
					.edgesIgnoringSafeArea(.all)
				VStack{
					Group{
					VStack{
						TextField("Weapon name", text: $name)
							.padding()
						Picker(selection: $unitSelect, label: Text("Select Unit"), content: {
							ForEach(self.units, id: \.id) { unit in
								HStack{
									Text("\(unit.name ?? "")")
								}
							}
						})
					}
					}
					Group{
					HStack{
						Text("Attacks: \(attacks, specifier: "%.0f")")
						Spacer()
						Button("-"){
							if self.attacks != 0.0 {
								self.attacks -= 1.0
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
						
						Button("+"){
							if self.attacks != 100.0 {
								self.attacks += 1.0
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
					}
					HStack{
						Text("To Hit: \(toHit)")
						Spacer()
						Button("-"){
							if self.toHit != 2 {
								self.toHit -= 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
						
						Button("+"){
							if self.toHit != 6 {
								self.toHit += 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
						
					}
					HStack{
						Text("To Wound: \(toWound)")
						Spacer()
						Button("-"){
							if self.toWound != 2 {
								self.toWound -= 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5.0)))
						
						Button("+"){
							if self.toWound != 6 {
								self.toWound += 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5.0)))
					}
					HStack{
						Text("Rend: \(toRend)")
						Spacer()
						Button("-"){
							if self.toRend != 0 {
								self.toRend -= 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
						
						Button("+"){
							if self.toRend != 6 {
								self.toRend += 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
					}
					HStack{
						Text("Save: \(toSave)")
						Spacer()
						Button("-"){
							if self.toSave != 2 {
								self.toSave -= 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
						
						Button("+"){
							if self.toSave != 6 {
								self.toSave += 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
					}
					HStack{
						Text("Damage: \(damage)")
						Spacer()
						Button("-"){
							if self.damage != 1 {
								self.damage -= 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
						
						Button("+"){
							if self.damage != 6 {
								self.damage += 1
							}
						}
						.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 5)))
					}
					VStack{
						Text("\(avgDmg.calc(attacks: attacks, toHit: Double(toHit), toWound: Double(toWound), toRend: Double(toRend), damage: Double(damage), toSave: Double(toSave)), specifier: "%.2f")")
							.fontWeight(.bold)
							.font(.subheadline)
							.padding()
						Button("Save"){
							let weapon = Weapon(context: self.moc)
							weapon.id = UUID()
							weapon.name = self.name
							weapon.toSave = Int16(self.toSave)
							weapon.toRend = Int16(self.toRend)
							weapon.attacks = Int16(self.attacks)
							weapon.toWound = Int16(self.toWound)
							weapon.toHit = Int16(self.toHit)
							weapon.damage = Int16(self.damage)
							weapon.avgDmg = self.avgDmg.calc(attacks: self.attacks, toHit: Double(self.toHit), toWound: Double(self.toWound), toRend: Double(self.toRend), damage: Double(self.damage), toSave: Double(self.toSave))
							try? self.moc.save()
							self.presentationMode.wrappedValue.dismiss()
						}
						.buttonStyle(LightButtonStyle(shape: Circle()))
					}
					.padding()
					}
				}
			.padding()
			}
			.navigationBarTitle("Save Weapon")
			.navigationBarItems(trailing: Button("Back") {
				self.presentationMode.wrappedValue.dismiss()})
		}
	}
}

