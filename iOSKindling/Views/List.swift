//
//  BookList.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData
import SwiftUI

struct BookList: View {
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var store: Store

	var req: FetchRequest<Book>

	@State private var showDeletionAlert: Bool = false
	@State private var deletionIndices: IndexSet = []

	init(query: String) {
		let req: NSFetchRequest<Book> = Book.fetchRequest()
		req.sortDescriptors = [
			NSSortDescriptor(keyPath: \Book.author, ascending: true),
			NSSortDescriptor(keyPath: \Book.title, ascending: false)
		]
		if query.count > 0 {
			req.predicate = NSPredicate(format: "title CONTAINS[c] %@", query as CVarArg)
		}
		self.req = FetchRequest(fetchRequest: req)
	}

	var body: some View {
		let books = req.wrappedValue
		return List {
			ForEach(books, id: \.id) { book in
				NavigationLink(destination: BookDetail(book: book)) {
					BookRow(book: book)
				}
			}
			.onDelete { indices in
				self.deletionIndices = indices
				self.showDeletionAlert = true
			}
			.alert(isPresented: self.$showDeletionAlert) {
				let book = books[self.deletionIndices.first!]
				return Alert(title: Text("Delete \(book.title)?"),
							 primaryButton: .destructive(Text("Delete")) { self.context.delete(book) },
							 secondaryButton: .cancel())
			}
		}
	}
}

struct BookList_Previews: PreviewProvider {
	static var previews: some View {
		BookList(query: "")
	}
}
