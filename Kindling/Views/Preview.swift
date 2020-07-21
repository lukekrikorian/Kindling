//
//  Preview.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-28.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData
import SwiftUI

#if os(macOS)
import Cocoa
#endif

public class Preview {
	var context: NSManagedObjectContext
	var books: [Book]
	var book: Book
	var store: Store
	var image: Image

	init() {
		#if os(iOS)
		self.image = Image(systemName: "book.fill")
		#else
		self.image = Image(nsImage: NSImage.init(named: NSImage.touchBarBookmarksTemplateName)!)
		#endif
		
		self.context = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
		self.books = []
				
		self.book = Book(context: self.context)
		book.title = "The Culture of Narcissism"
		book.author = "Christopher Lasch"
		book.authorURL = "https://books.apple.com/us/artist/christopher-lasch/566286923"
		book.coverURL = "https://is5-ssl.mzstatic.com/image/thumb/Publication4/v4/a4/8b/2e/a48b2e6a-d132-73f4-66ed-bd2a3f023b62/source/0x200h.jpg"
		
		let clipping1 = Clipping(context: self.context)
		clipping1.text = "It has resolved personal worth into exchange value, and in place of the numberless indefeasible chartered freedoms, has set up that single, unconscionable freedom—Free Trade. In one word, for exploitation, veiled by religious and political illusions, it has substituted naked, shameless, direct, brutal exploitation."
		clipping1.book = self.book
		
		let clipping2 = Clipping(context: self.context)
		clipping2.text = "Neither drugs nor fantasies of destruction—even when the fantasies are objectified in “revolutionary praxis”—appease the inner hunger from which they spring."
		clipping2.book = self.book
		
		books.append(self.book)
		books.append(self.book)

		self.store = Store()
		store.selectedClipping = clipping2
	}
	

}

struct PreviewWrapper: ViewModifier {
	func body(content: Content) -> some View {
		content
			.environment(\.managedObjectContext, PreviewContext.context)
			.environmentObject(PreviewContext.store)
	}
}
