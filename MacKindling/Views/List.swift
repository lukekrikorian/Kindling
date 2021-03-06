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

	var body: some View {
		List(selection: self.$store.selectedBook) {
			Section(header: Text("BOOKS")) {
				ForEach(self.Books, id: \.id) { book in
					Group {
						if book.clippings.contains(self.store.searchQuery ?? "") {
							BookRow(book: book, placeholderImage: PreviewContext.image)
								.contextMenu { RowContextMenu(book: book) }
								.tag(book)
						}
					}
				}
			}
		}
		.frame(minWidth: 275)
		.listStyle(SidebarListStyle())
	}
}

struct RowContextMenu: View {
	@Environment(\.managedObjectContext) var context
	var book: Book
	var body: some View {
		Button("Delete Book", action: {
			self.context.delete(self.book)
		})
	}
}

// struct BookList_Previews: PreviewProvider {
//	static var previews: some View {
//		BookList()
//			.modifier(PreviewWrapper())
//			.frame(width: 275)
//	}
// }
