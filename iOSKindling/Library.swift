//
//  Library.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-22.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct Library: View {
	@EnvironmentObject var store: Store
	@Environment(\.managedObjectContext) var context
	@State private var sheetToggle = false
	
	var body: some View {
		NavigationView {
			BookList(query: self.store.searchQuery)
				.navigationBarTitle(Text("Library")
					.font(.system(.body, design: .serif)))
				.navigationBarItems(trailing: addButton)
		}
		.sheet(isPresented: self.$sheetToggle) {
			ClippingForm(type: .new, sheetBinding: self.$sheetToggle)
				.environment(\.managedObjectContext, self.context)
		}
	}

	var addButton: some View {
		Button(action: { self.sheetToggle = true }) {
			Image(uiImage: UIImage(systemName: "plus.circle.fill")!)
				.imageScale(.large)
		}
	}
}

struct Library_Previews: PreviewProvider {
	static var previews: some View {
		Library()
	}
}
