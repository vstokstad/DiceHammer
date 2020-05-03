//
//  ContentView.swift
//  MultipeerSender
//
//  Created by Vilhelm Stokstad on 2020-03-10.
//  Copyright © 2020 Vilhelm Stokstad. All rights reserved.
//

import SwiftUI
import MultipeerKit
import Combine

final class ViewModel: ObservableObject {
	@Published var message: String = ""
	@Published var selectedPeers: [Peer] = []
	
	func toggle(_ peer: Peer) {
		if selectedPeers.contains(peer) {
			selectedPeers.remove(at: selectedPeers.firstIndex(of: peer)!)
		} else {
			selectedPeers.append(peer)
		}
	}
}

final class DiceModel: ObservableObject {
	var d6 = {()->Int in var roll = Int.random(in: 1...6)
		return roll}
	@Published var diceRolls = [Int]()
	@Published var hits = 0
	@Published var misses = 0
	@Published var rerolls = 0
	@Published var numberOfDice = 0
	@Published var toKeep = 4
	func Roll(numberOfDice: Int) {
		diceRolls.removeAll()
		for _ in 0..<numberOfDice {
			diceRolls.append(d6())
		}
	}
}

struct ConnectView: View {
	@Environment(\.managedObjectContext) var moc
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel = ViewModel()

	@EnvironmentObject var dataSource: MultipeerDataSource
	@ObservedObject var diceModel = DiceModel()
	@ObservedObject var dice = Dice()
	@State private var showErrorAlert = false
	var transceiver = MultipeerTransceiver()
	
	func DiceRecieve() {
		transceiver.receive(DicePackage.self) { payload in
			print("Got my thing! \(payload)")
		}
	}
	let payload: DicePackage
	
	var body: some View {
		VStack{
			Text("DiceRollConnect")
			Picker(selection: $diceModel.numberOfDice, label: Text("Number of Dice")) {
				ForEach(0..<20) { i in
					Text("\(i)")
				}
			}
//			.onAppear(){
//				self.transceiver.resume()
//			}
			Button("Roll and send to opponent") {
				self.diceModel.Roll(numberOfDice: self.diceModel.numberOfDice)
				self.sendToSelectedPeers(message: self.payload)
			}
			
			VStack(alignment: .leading) {
				Text("Peers").font(.system(.headline)).padding()
				
				List {
					ForEach(dataSource.availablePeers) { peer in
						HStack {
							Circle()
								.frame(width: 12, height: 12)
								.foregroundColor(peer.isConnected ? .green : .gray)
							
							Text(peer.name)
							
							Spacer()
							
							if self.viewModel.selectedPeers.contains(peer) {
								Image(systemName: "checkmark")
							}
						}.onTapGesture {
							self.viewModel.toggle(peer)
						}
					}
				}
			}
		}.alert(isPresented: $showErrorAlert) {
			Alert(title: Text("Please select a peer"), message: nil, dismissButton: nil)
		}
	}
	
	
	func sendToSelectedPeers(message: DicePackage) {
		guard !self.viewModel.selectedPeers.isEmpty else {
			showErrorAlert = true
			return
		}
		
		var payload = DicePackage(hitRolls: diceModel.diceRolls, hits: diceModel.hits, misses: diceModel.misses, rerolls: 0)
		dataSource.transceiver.send(payload, to: viewModel.selectedPeers)
	}
}

struct ConnectView_Preview: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
