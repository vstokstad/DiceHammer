//
//  ContentView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-01-18.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//
import Foundation
import SwiftUI
import GameKit
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.editMode) var editMode
   
    @FetchRequest(entity: Unit.entity(), sortDescriptors: [NSSortDescriptor.init(key: "name", ascending: true)]) var units: FetchedResults<Unit>
@State private var addProfileViewShowing = false
    @State private var savedProfilesViewShowing = false
    @State private var selection: Int = 0
    @ObservedObject var avgDmg = AvgDmg()
    var d6 = Int.random(in: 1...6)
   
    @State public var attacks = 1
    @State public var toHit = 2
    @State public var toWound = 2
    @State public var toRend = 1
    @State public var toSave = 4
    @State public var damage = 1
    @State private var d3Toggle = false
    @State private var d6Toggle = false
    
    
    var body: some View {
            TabView(selection: $selection){
           
         VStack{
            Text("Avg Dmg Calc")
                .font(.largeTitle)
                .bold()
            Spacer()
            VStack{
              
            Text("Attacks")
                Picker(selection: $attacks, label: Text("Attacks")) {
                  ForEach(0..<100) {
                      Text("\($0)")
                  }
              }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()
            .padding(.all, -50.0)
            
            Text("To Hit")
            Picker(selection: $toHit, label: Text("To Hit")) {
                ForEach(0..<7) {
                    Text("\($0)")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("To Wound")
            Picker(selection: $toWound, label: Text("To Wound")) {
                  ForEach(0..<7) {
                      Text("\($0)")
                  }
              }
              .pickerStyle(SegmentedPickerStyle())
            
            Text("Rend")
            Picker(selection: $toRend, label: Text("Rend")) {
                  ForEach(0..<7) {
                      Text("\($0)")
                  }
              }
              .pickerStyle(SegmentedPickerStyle())
            }
            VStack{
            Text("To Save")
            Picker(selection: $toSave, label: Text("To Save")) {
                  ForEach(0..<7) {
                      Text("\($0)")
                  }
              }
              .pickerStyle(SegmentedPickerStyle())
           
                   
            Text("Damage")
//                HStack{
//                Toggle("D3", isOn: $d3Toggle)
//                    Toggle("D6", isOn: $d6Toggle)
//                }
            Picker(selection: $damage, label: Text("damage")) {
                  ForEach(0..<7) {
                    Text("\($0)")
                    
                  }
              }
              .pickerStyle(SegmentedPickerStyle())
//                .disabled(d3Toggle)
           
                
       
                HStack{
                    Text("Average Damage Output:")
                        .font(.headline)
                    
                 Text("\(avgDmg.calc(attacks: Double(attacks), toHit: Double(toHit), toWound: Double(toWound), toRend: Double(toRend), damage: Double(damage), toSave: Double(toSave)), specifier: "%.2f")")
                .fontWeight(.bold)
                .font(.title)
                    .underline()
                    }}
              
            Spacer()
            HStack{
               
            Button(action:  {
                
                self.addProfileViewShowing.toggle()
                
                
            }) {
                VStack {
                Image(systemName: "tray.and.arrow.down.fill")
                Text("Save Profile")
                }
                }
            .sheet(isPresented: self.$addProfileViewShowing) {
                AddProfileView(attacks: self.attacks, toHit: self.toHit, toWound: self.toWound, toRend: self.toRend, toSave: self.toSave, damage: self.damage, avgDmg: self.avgDmg.calc(attacks: Double(self.attacks), toHit: Double(self.toHit), toWound: Double(self.toWound), toRend: Double(self.toRend), damage: Double(self.damage), toSave: Double(self.toSave))).environment(\.managedObjectContext, self.moc)
                }
            .padding()
                
                Button(action:  {
                    self.savedProfilesViewShowing.toggle()
                }) {
                    VStack{
                    Image(systemName: "archivebox")
                    Text("Saved Profiles")
                    }}
                    .sheet(isPresented: self.$savedProfilesViewShowing) {
                        SavedProfilesView().environment(\.managedObjectContext, self.moc)
                }
                .disabled(units.isEmpty)
            .padding()
                
          
                  }
            Spacer()
         }
         .tabItem
            {
             VStack {
                Image(systemName: "star")
                Text("AvgDmg")
                    }
                }
                .tag(0)
                
              
                  BasicDiceRollView().environment(\.managedObjectContext, self.moc)

                
            .tabItem {
                    VStack {
                        Image(systemName: "star")
                        Text("Basic DiceRoller")
                    }
                }
                .tag(1)
                
                Text("Third View")
                    .font(.title)
                    
                    .tabItem {
                        VStack {
                            Image(systemName: "star")
                            Text("Basic DiceRoll")
                        }
                }
                .tag(2)
        }
    

    }

       
    }



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)

    }
}
