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
import MultipeerKit


struct ContentView: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var dataSource: MultipeerDataSource
	
	@FetchRequest(entity: Weapon.entity(), sortDescriptors: [NSSortDescriptor.init(key: "name", ascending: true)]) var weapons: FetchedResults<Weapon>
	@FetchRequest(entity: Unit.entity(), sortDescriptors: []) var units: FetchedResults<Unit>
	
	@State private var addProfileViewShowing = false
	@State private var savedProfilesViewShowing = false
	@State private var comBineProfileViewShowing = false

	@State private var attacks = 1.0


	
	var body: some View {
		
		ZStack{
			LinearGradient(Color.lightStart, Color.lightEnd)
				.edgesIgnoringSafeArea(.all)

			VStack{
//					DiceRollView
				BasicDiceRollView().environment(\.managedObjectContext, self.moc).environmentObject(dataSource)
				}
		}
		.colorScheme(.light)
	}

}


struct ContentView_Previews: PreviewProvider {
	
	static var previews: some View {
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		return ContentView().environment(\.managedObjectContext, context)
	
	}
}
