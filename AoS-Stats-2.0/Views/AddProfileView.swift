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

struct AddProfileView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""

    var attacks: Int
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
        TextField("Profile Name", text: $name)
                    }}
                Section{
                        Text("Attacks: \(attacks)")
                        Text("To Hit: \(toHit)")
                        Text("To Wound: \(toWound)")
                        Text("Rend: \(toRend)")
                        Text("Save: \(toSave)")
                        Text("Damage: \(damage)")
                }
                
            Button("Save Profile")
                        {
                let unit = Weapon(context: self.moc)
                unit.id = UUID()
                unit.name = self.name
                unit.toSave = Int16(self.toSave)
                unit.toRend = Int16(self.toRend)
                unit.attacks = Int16(self.attacks)
                unit.toWound = Int16(self.toWound)
                unit.toHit = Int16(self.toHit)
                unit.damage = Int16(self.damage)
                unit.avgDmg = Double(self.avgDmg)
                try? self.moc.save()
                self.presentationMode.wrappedValue.dismiss()
                    }
            .font(.headline)
                    }
        .navigationBarTitle("Save Profile")
            .navigationBarItems(leading: EditButton(), trailing: Button("Back") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
struct AddProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileView(attacks: ContentView().attacks, toHit: ContentView().toHit, toWound: ContentView().toWound, toRend: ContentView().toRend, toSave: ContentView().toSave, damage: ContentView().damage, avgDmg: AvgDmg().calc(attacks: Double(ContentView().attacks), toHit: Double(ContentView().toHit), toWound: Double(ContentView().toWound), toRend: Double(ContentView().toRend), damage: Double(ContentView().damage), toSave: Double(ContentView().toSave)))
    }
}
