//
//  ContentView.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-08.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import NotificationCenter
import SwiftUI

struct ContentView: View {
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var store: Store

	@State private var sheetToggle = false

	var body: some View {
		NavigationView {
			BookList(query: self.store.searchQuery)
				.navigationBarTitle("Library")
				.navigationBarItems(trailing: addButton)
		}
		.sheet(isPresented: self.$sheetToggle) {
			ClippingForm(type: .new, sheetBinding: self.$sheetToggle)
				.environment(\.managedObjectContext, self.context)
		}
		.onReceive(NotificationCenter.default.publisher(for: .deviceShake)) { _ in
			self.context.undo()
		}
	}

	var addButton: some View {
		Button(action: { self.sheetToggle = true }) {
			Image(uiImage: UIImage(systemName: "plus.circle.fill")!)
				.imageScale(.large)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
