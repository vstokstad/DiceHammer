//
//  SavedProfilesView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-20.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation
import GameKit
import UIKit

struct SavedProfilesView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Weapon.entity(), sortDescriptors: []) var weapons: FetchedResults<Weapon>
    @FetchRequest(entity: Unit.entity(), sortDescriptors: []) var units: FetchedResults<Unit>
    func deleteWeapon(at offsets: IndexSet) {
        for offset in offsets {
            let weapon = weapons[offset]
            moc.delete(weapon)
        }
        
        try? moc.save()
    }
    func deleteUnit(at offsets: IndexSet) {
        for offset in offsets {
            let unit = units[offset]
            moc.delete(unit)
        }
        try? moc.save()
    }
    var body: some View {
        NavigationView{
        VStack{
            List {
                Section{
                    ForEach(self.units, id: \.id) { unit in
                        VStack{
                            Text("\(unit.name ?? "noName Unit")")
                                .font(.headline)
                            Text("Avg Dmg: \(unit.totalAvgDmg, specifier: "%.2f")")
                                .font(.subheadline)
							Text("Weapons: \(unit.toWeapon!)")
                          
                            }
                        
                    }
                    .onDelete(perform: deleteUnit)
                }
               
                
                Section{
                    ForEach(self.weapons, id: \.id) { weapon in
                    VStack{
                        Text("\(weapon.name ?? "noName Weapon")")
                            .font(.headline)
                      
                        HStack{
                            Text("Attacks: \(weapon.attacks)")
                            Text("To Hit: \(weapon.toHit)")
                        }
                        HStack{
                            Text("To Wound: \(weapon.toWound)")
                            Text("To Rend: \(weapon.toRend)")
                        }
                        HStack{
                            Text("To Save: \(weapon.toSave)")
                            Text("Damage: \(weapon.damage)")
                        }
                            Text("Avg Dmg: \(weapon.avgDmg, specifier: "%.2f")")
                    .font(.headline)
                    .underline()
                        }
                   
                    }
            .onDelete(perform: deleteWeapon)
               
                }
           
            }
           
            }
        
        .navigationBarTitle("Saved Profiles")
        .navigationBarItems(leading: EditButton(), trailing:  Button("Back") {
            self.presentationMode.wrappedValue.dismiss()
            })
        }
        }
    }
        



struct SavedProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        SavedProfilesView()
    }
}
