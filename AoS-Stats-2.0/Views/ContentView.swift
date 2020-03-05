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
import ARKit

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.editMode) var editMode
   
    @FetchRequest(entity: Weapon.entity(), sortDescriptors: [NSSortDescriptor.init(key: "name", ascending: true)]) var units: FetchedResults<Weapon>
    @State private var addProfileViewShowing = false
    @State private var savedProfilesViewShowing = false
    @State private var comBineProfileViewShowing = false
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
		
		
            TabView(selection: $selection){
				
				AvgDmgCalcView()
//					First View
         .tabItem {
             VStack {
                Image(systemName: "star")
                Text("AvgDmg")
                    }
                }
                .tag(0)
				
		
               BasicDiceRollView().environment(\.managedObjectContext, self.moc)
//				Second View
		
            .tabItem {
                    VStack {
                        Image(systemName: "star")
                        Text("Basic DiceRoller")
                    }
                }
                .tag(1)
				VStack{
            Text("third View")
			}
//					Third view
                    .tabItem {
                        VStack {
                            Image(systemName: "star")
                            Text("Basic DiceRoll")
					}
                }
                .tag(2)
			}
			
		}
		.edgesIgnoringSafeArea(.all)
	}
}



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)

    }
}
