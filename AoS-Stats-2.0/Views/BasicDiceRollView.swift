//
//  BasicDiceRollView.swift
//  AoS-Stats-2.0
//
//  Created by Vilhelm Stokstad on 2020-02-21.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import Foundation
import SwiftUI
import GameKit
import CoreData
import Combine

struct BasicDiceRollView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: HitRolls.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \HitRolls.objectID, ascending: false)]) var hitRolls: FetchedResults<HitRolls>
    @FetchRequest(entity: WoundRolls.entity(), sortDescriptors: []) var woundRolls: FetchedResults<WoundRolls>
   
    @State var dice = 2
    @State private var toHit = 4
    @State private var toWound = 4
    @State private var toSave = 4
    @State private var hits = 0
    
    func d6() -> Int16
    {
        return Int16.random(in: 1...6)
    }

    func deleteHitRoll(at offsets: IndexSet) {
        for offset in offsets {
            let hitRoll = hitRolls[offset]
            moc.delete(hitRoll)
              try? moc.save()
        }
    }
    func hitCalc(at offsets: IndexSet) {
            for offset in offsets {
                let hitRoll = hitRolls[offset]
                if hitRoll.hitRoll >= Int16(self.toHit) {
                    hits += 1
                }
              
            }
        }

  
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker(selection: $dice, label: Text("Dice")) {
                        ForEach(0..<200) {
                            Text("\($0)")
                        }
                        
                    }
                }
                Section{
                    List {
                        ForEach(self.hitRolls, id: \.id) { hitRoll in
                        VStack{
                            Text("Hit Roll: \(hitRoll.hitRoll)")
                                .font(.headline)
                            
                        }
                         
                        }
                        .onDelete(perform: deleteHitRoll)
                                            
                        }
                    }
                
                Section{
                    HStack{
                        Button("Roll Hits") {
                            var i = 0
                            while(self.dice > i) {
                                let hitRoll = HitRolls(context: self.moc)
                                hitRoll.id = UUID()
                                hitRoll.hitRoll = Int16(self.d6())
                                try? self.moc.save()
                                i += 1
                                if hitRoll.hitRoll > Int16(self.toHit) {
                                    self.hits += 1
                                }
                            }
                            self.hitCalc(at: IndexSet())
                           
                }
                        Spacer()
                        
                        Text("Hits: \(hits)")
//              Rerolla ettor, assign nytt värde till hitRoll
//                        Button("Reroll 1s") {
//                            ForEach(hitRolls, id: \.id) { hitroll in
////                                let hitRoll = HitRolls(context: self.moc)
//
//                                if(hitRoll.hitRoll == Int16(1)) {
//                                    hitRoll.hitRoll = self.d6()
//
//                                }
//
//                            }
//                        }
                    }
//                    Picker för att välja vilka slag som ska sparas
                    Picker(selection: $toHit, label: Text("Hit rolls to keep")) {
                        ForEach(0..<7) {
                            Text("\($0)")
                        }
                       
                    }
                .pickerStyle(SegmentedPickerStyle())
                    
                }
                
                }
        
            .navigationBarTitle("Basic Dice Roll")
        .navigationBarItems(leading: EditButton())
        }
        }
        
    }

   
    


struct BasicDiceRollView_Previews: PreviewProvider {
    static var previews: some View {
     
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return BasicDiceRollView().environment(\.managedObjectContext, context)
    }
}
