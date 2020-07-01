//
//  List.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-24.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct BookList: View {
	@EnvironmentObject var store: Store
	@FetchRequest(entity: Book.entity(), sortDescriptors: [
		NSSortDescriptor(keyPath: \Book.author, ascending: true),
		NSSortDescriptor(keyPath: \Book.title, ascending: false)
	]) var Books: FetchedResults<Book>
	var filteredBooks: [Book] {
		return Books.filter { $0.clippings!.containsQuery(store.searchQuery ?? "") }
	}
	
	var body: some View {
		return List(selection: self.$store.listSelection) {
			ForEach(self.filteredBooks, id: \.id) { book in
				BookRow(Book: book)
					.contextMenu {
						Button(action: { context.delete(book) }) {
							Text("Delete Book")
								.foregroundColor(Color.red)
						}
					}
					.tag(book)
			}
			EmptyView()
		}
		.id(self.filteredBooks)
		.listStyle(SidebarListStyle())
		.frame(minWidth: 275)
	}
}

// struct BookList_Previews: PreviewProvider {
//	static var previews: some View {
//		BookList()
//			.modifier(PreviewWrapper())
//			.frame(width: 275)
//	}
// }
