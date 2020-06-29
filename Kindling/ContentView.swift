//
//  ContentView.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var store: Store

	var body: some View {
		NavigationView {
			BookList()
			if self.store.selectedBook != nil && self.store.selectedBook?.title != nil {
				BookDetail(Book: self.store.selectedBook!)
			} else {
				Text("No selection")
					.foregroundColor(Color.secondary)
					.font(.system(size: 20))
					.fontWeight(.bold)
					.opacity(0.5)
					.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
			}
		}
	}
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//			.modifier(PreviewWrapper())
//			.frame(width: 600)
//	}
//}
