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
    @Environment(\.editMode) var editMode
    
    @FetchRequest(entity: Unit.entity(), sortDescriptors: []) var units: FetchedResults<Unit>
    @FetchRequest(entity: CombinedUnit.entity(), sortDescriptors: []) var combinedUnits: FetchedResults<CombinedUnit>
    func deleteProfile(at offsets: IndexSet) {
        for offset in offsets {
            let unit = units[offset]
            moc.delete(unit)
        }
        
        try? moc.save()
    }
    func deleteCombined(at offsets: IndexSet) {
        for offset in offsets {
            let unit = combinedUnits[offset]
            moc.delete(unit)
        }
        try? moc.save()
    }
    var body: some View {
        NavigationView{
        VStack{
            List {
                Section{
                    ForEach(self.combinedUnits, id: \.combineId) { combinedUnit in
                        VStack{
                            Text("\(combinedUnit.combineName ?? "noName Unit")")
                                .font(.headline)
                            Text("Avg Dmg: \(combinedUnit.totalAvgDmg, specifier: "%.2f")")
                                .font(.subheadline)
                            ForEach({ ()-> [Unit] in
                                var subUnits: [Unit] = []
                                for unit in self.units {
                                    if unit.id == combinedUnit.combineId {
                                    subUnits.append(unit)
                                    }
                                }
                                return subUnits
                            }(), id: \.self) { _ in
								Text("profiles: \(combinedUnit.combineName ?? "")")
                            }
                            }
                        
                    }
                    .onDelete(perform: deleteCombined)
                }
               
                
                Section{
                    ForEach(self.units, id: \.id) { unit in
                    VStack{
                        Text("\(unit.name ?? "noName profile")")
                            .font(.headline)
                      
                        HStack{
                            Text("Attacks: \(unit.attacks)")
                            Text("To Hit: \(unit.toHit)")
                        }
                        HStack{
                            Text("To Wound: \(unit.toWound)")
                            Text("To Rend: \(unit.toRend)")
                        }
                        HStack{
                            Text("To Save: \(unit.toSave)")
                            Text("Damage: \(unit.damage)")
                        }
                            Text("Avg Dmg: \(unit.avgDmg, specifier: "%.2f")")
                    .font(.headline)
                    .underline()
                        }
                   
                    }
            .onDelete(perform: deleteProfile)
               
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
