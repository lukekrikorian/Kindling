//
//  NavigationMaster.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-24.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct NavigationMaster: View {
	@EnvironmentObject var store: Store
	var books: Books = []
	var body: some View {
		var filtered = books.filtered(by: self.store.searchQuery)
		return List(selection: self.$store.selectedBook) {
			ForEach(filtered, id: \.id) { book in
				BookRow(Book: book).tag(book)
			}
		}
		.listStyle(SidebarListStyle())
		.id(self.store.searchQuery)
		.frame(minWidth: 275)
	}
}

// struct Sidebar_Previews: PreviewProvider {
//    static var previews: some View {
//        Sidebar(SelectedBook: Binding.constant(nil), SearchQuery: Binding.constant(""))
//    }
// }
