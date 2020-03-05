//
//  AvgDmgCalcView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-03-05.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI

struct AvgDmgCalcView: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.editMode) var editMode
	
	@FetchRequest(entity: Weapon.entity(), sortDescriptors: [NSSortDescriptor.init(key: "name", ascending: true)]) var weapons: FetchedResults<Weapon>
	
	@State private var addWeaponViewShowing = false
	@State private var savedProfilesViewShowing = false
	@State private var comBineProfileViewShowing = false
	@State private var addUnitViewShowing = false
	@State private var selection: Int = 0
	@ObservedObject var avgDmg = AvgDmg()
	//    var d6 = Int.random(in: 1...6)
	
	@State public var attacks = 1.0
	@State public var toHit = 2
	@State public var toWound = 2
	@State public var toRend = 1
	@State public var toSave = 4
	@State public var damage = 1
	@State private var d3Toggle = false
	@State private var d6Toggle = false
	var body: some View {
		ZStack{
			LinearGradient(Color.lightStart, Color.lightEnd)
			
			ScrollView{
				VStack{
					HStack{
						Button(action:  {
							self.addUnitViewShowing.toggle()
						}) {
							VStack {
								Image(systemName: "star.fill")
								Text("New Unit")
									.font(.caption)
							}
						}
						.sheet(isPresented: self.$addUnitViewShowing) {
							AddUnitView()
						}

						Spacer()
						Text("Avg Dmg Calc")
							.font(.headline)
							.padding()
						Spacer()
						Button(action:  {
							self.addWeaponViewShowing.toggle()
						}) {
							VStack {
								Image(systemName: "square.and.arrow.down.fill")
								Text("Save Weapon")
									.font(.caption)
							}
						}
						.sheet(isPresented: self.$addWeaponViewShowing) {
							AddWeaponView(attacks: self.attacks, toHit: self.toHit, toWound: self.toWound, toRend: self.toRend, toSave: self.toSave, damage: self.damage).environment(\.managedObjectContext, self.moc)
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
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
							Button("+"){
								if self.attacks != 100.0 {
									self.attacks += 1.0
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
						}
						Slider(value: $attacks, in: 1.0...101.0, step: 1.0)
						
						HStack{
							Text("To Hit: \(self.toHit)+")
							Spacer()
							Button("-"){
								if self.toHit != 0 {
									self.toHit -= 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
							Button("+"){
								if self.toHit != 6 {
									self.toHit += 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
						}
						HStack{
							Text("To Wound: \(toWound)+")
							Spacer()
							Button("-"){
								if self.toWound != 0 {
									self.toWound -= 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
							Button("+"){
								if self.toWound != 6 {
									self.toWound += 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
						}
						HStack{
							Text("Rend: -\(toRend)")
							Spacer()
							Button("-"){
								if self.toRend != 0 {
									self.toRend -= 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
							Button("+"){
								if self.toRend != 6 {
									self.toRend += 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
						}
						HStack{
							Text("To Save: \(toSave)+")
							Spacer()
							Button("-"){
								if self.toSave != 0 {
									self.toSave -= 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
							Button("+"){
								if self.toSave != 7 {
									self.toSave += 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
						}
						HStack{
							
							Text("Damage: \(damage)")
							Spacer()
							Toggle("d3", isOn: $d3Toggle)
								.font(.footnote)
								
							Spacer()
							Button("-"){
								if self.damage != 0 {
									self.damage -= 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
							Button("+"){
								if self.damage != 10 {
									self.damage += 1
								}
							}
							.buttonStyle(LightButtonStyle(shape: RoundedRectangle(cornerRadius: 10)))
							.labelsHidden()
							
						}
						HStack{
						
							Text("Reroll ones")
							Text("Reroll ones")
							Text("sixes explode")
						}
						.font(.caption)
						HStack{
							Text("Average Damage Output:")
								.font(.subheadline)
							
							Text("\(avgDmg.calc(attacks: attacks, toHit: Double(toHit), toWound: Double(toWound), toRend: Double(toRend), damage: Double(damage), toSave: Double(toSave)), specifier: "%.2f")")
								.fontWeight(.bold)
								.font(.subheadline)
						}
						.padding()
					}
					Group{
						HStack{
							Spacer()
							Button(action: {
								self.comBineProfileViewShowing.toggle()
							}) {
								VStack{
									Image(systemName: "square.and.arrow.down.on.square.fill")
									Text("Add to Unit")
										.font(.caption
									)
									
								}
								.multilineTextAlignment(.center)
							}
							.sheet(isPresented: self.$comBineProfileViewShowing) {
								CombineProfileView(attacks: self.attacks, toHit: self.toHit, toWound: self.toWound, toRend: self.toRend, toSave: self.toSave, damage: self.damage, avgDmg: self.avgDmg.calc(attacks: self.attacks, toHit: Double(self.toHit), toWound: Double(self.toWound), toRend: Double(self.toRend), damage: Double(self.damage), toSave: Double(self.toSave))).environment(\.managedObjectContext, self.moc)
							}
							Spacer()
							Button(action:  {
								self.savedProfilesViewShowing.toggle()
							}) {
								VStack{
									Image(systemName: "archivebox")
									Text("Compare Units")
										.font(.caption)
								}}
								.sheet(isPresented: self.$savedProfilesViewShowing) {
									SavedProfilesView().environment(\.managedObjectContext, self.moc)
							}
							.disabled(weapons.isEmpty)
							Spacer()
							
						}
						.font(.subheadline)
						Spacer()
					}
				}}
				.padding()
		}.edgesIgnoringSafeArea(.all)
	}
}

struct AvgDmgCalcView_Previews: PreviewProvider {
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		return ContentView().environment(\.managedObjectContext, context)
	}
}
