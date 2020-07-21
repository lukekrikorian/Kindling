//
//  Header.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-28.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData
import SwiftUI
import URLImage

struct BookHeader: View {
	@EnvironmentObject var store: Store
	var book: Book
	var imageWidth: CGFloat = 100
	var body: some View {
		let hasAuthorLink = self.book.authorURL != nil
		return VStack(alignment: .leading) {
			HStack(alignment: .top) {
				BookCover(book: book, placeholder: PreviewContext.image, width: self.imageWidth)
				VStack (alignment: .leading) {
					Text(book.title)
						.font(.headline)
						.fontWeight(.semibold)
						.lineLimit(nil)

					Text(book.author)
						.font(.subheadline)
						.foregroundColor(hasAuthorLink ? Color.blue : Color.primary)
						.onTapGesture { if hasAuthorLink { self.openAuthorURL() } }
				}
			}
			Divider()
		}.padding([.leading, .top, .trailing])
	}

	func openAuthorURL() {
		self.store.bridge.openURL(self.book.authorURL!)
	}
}

struct BookHeader_Previews: PreviewProvider {
	static var previews: some View {
		return BookHeader(book: PreviewContext.book)
			.modifier(PreviewWrapper())
			.frame(width: 400)
	}
}
