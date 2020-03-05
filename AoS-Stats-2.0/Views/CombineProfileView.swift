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
    @State private var combinedName = ""
    @State private var unitName = ""
    @State private var unitSelect = 0
    var attacks: Double
    var toHit: Int
    var toWound: Int
    var toRend: Int
    var toSave: Int
    var damage: Int
    var avgDmg: Double
  
  
    
    var body: some View {
        NavigationView {
            Form{
                Section{
                    VStack{
						if units.isEmpty {
                            Picker(selection: $unitSelect, label: Text(weapons[unitSelect].name ?? "Select Unit")){
                                ForEach(self.weapons, id: \.id) { weapon in
                                    Text("\(weapon.name ?? "No saved profiles")")
                                
                                }
                            }
                        }
                        else {
                            Picker(selection: $unitSelect, label: Text(units[unitSelect].name ?? "Select Unit")){
                                ForEach(self.units, id: \.id) { unit in
                                    Text("\(unit.name ?? "No saved profiles")")
                                    
                                }
                            }
                        }
					}
					VStack {
						TextField("Profile name", text: $unitName)
						TextField("Combined Unit Name", text: $combinedName)
					}
                    
                }
            
                Section{
                    Text("Attacks: \(attacks, specifier: "%.0f")")
                    Text("To Hit: \(toHit)")
                    Text("To Wound: \(toWound)")
                    Text("Rend: \(toRend)")
                    Text("Save: \(toSave)")
                    Text("Damage: \(damage)")
                }
                
                Button("Save Profile")
                {
                    let unit = Unit(context: self.moc)
                    let weapon = Weapon(context: self.moc)
                    weapon.id = UUID()
                    weapon.name = self.unitName
                    weapon.toSave = Int16(self.toSave)
                    weapon.toRend = Int16(self.toRend)
                    weapon.attacks = Int16(self.attacks)
                    weapon.toWound = Int16(self.toWound)
                    weapon.toHit = Int16(self.toHit)
                    weapon.damage = Int16(self.damage)
                    weapon.avgDmg = Double(self.avgDmg)
                    if unit.name != self.combinedName || self.combinedName != "" {
					unit.id = UUID()
                    unit.name = self.combinedName
                    unit.totalAvgDmg = (Double(self.avgDmg) + Double(self.weapons[self.unitSelect].avgDmg))
						
                    }
                    else if unit.name == self.combinedName || self.combinedName == "" {
                        unit.totalAvgDmg = (Double(self.avgDmg) + Double(self.units[self.unitSelect].totalAvgDmg))
                    }
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
        CombineProfileView(attacks: ContentView().attacks, toHit: ContentView().toHit, toWound: ContentView().toWound, toRend: ContentView().toRend, toSave: ContentView().toSave, damage: ContentView().damage, avgDmg: AvgDmg().calc(attacks: Double(ContentView().attacks), toHit: Double(ContentView().toHit), toWound: Double(ContentView().toWound), toRend: Double(ContentView().toRend), damage: Double(ContentView().damage), toSave: Double(ContentView().toSave)))
    }
}

