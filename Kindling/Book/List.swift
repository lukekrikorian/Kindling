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
		let filteredBooks = Books.filter { $0.clippings!.contains(self.store.searchQuery) }
		return List(selection: self.$store.selectedBook) {
			ForEach(filteredBooks, id: \.id) { book in
				BookRow(Book: book).tag(book)
			}
		}
		.id(filteredBooks.count)
		.listStyle(SidebarListStyle())
		.frame(minWidth: 275)
	}
}

//struct BookList_Previews: PreviewProvider {
//	static var previews: some View {
//		BookList()
//			.modifier(PreviewWrapper())
//			.frame(width: 275)
//	}
//}
