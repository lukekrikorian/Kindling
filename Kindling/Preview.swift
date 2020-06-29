//
//  Preview.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-28.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa
import SwiftUI

var PreviewContext = Preview()

class Preview {
	var context: NSManagedObjectContext
	var books: [Book]
	var book: Book
	var store: Store

	init() {
		self.context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
		self.books = []
				
		self.book = Book(context: self.context)
		book.title = "The Culture of Narcissism"
		book.author = "Christopher Lasch"
		book.authorURL = "https://books.apple.com/us/artist/christopher-lasch/566286923"
		book.coverURL = "https://is5-ssl.mzstatic.com/image/thumb/Publication4/v4/a4/8b/2e/a48b2e6a-d132-73f4-66ed-bd2a3f023b62/source/0x200h.jpg"
		book.clippings = [
			"It has resolved personal worth into exchange value, and in place of the numberless indefeasible chartered freedoms, has set up that single, unconscionable freedom—Free Trade. In one word, for exploitation, veiled by religious and political illusions, it has substituted naked, shameless, direct, brutal exploitation.",
			"Neither drugs nor fantasies of destruction—even when the fantasies are objectified in “revolutionary praxis”—appease the inner hunger from which they spring."
		]
		
		books.append(self.book)
		books.append(self.book)

		self.store = Store()
		store.selectedClipping = book.clippings!.first
	}
	

}

struct PreviewWrapper: ViewModifier {
	func body(content: Content) -> some View {
		content
			.environment(\.managedObjectContext, PreviewContext.context)
			.environmentObject(PreviewContext.store)
	}
}
