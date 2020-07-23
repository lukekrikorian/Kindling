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

	var body: some View {
		Tabs {
			Library()
				.tab(title: "Library", image: "book")
			Text("Secondary View")
				.tab(title: "Search", image: "doc.text.magnifyingglass")
		}
		.onReceive(NotificationCenter.default.publisher(for: .deviceShake)) { _ in
			self.context.undo()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
