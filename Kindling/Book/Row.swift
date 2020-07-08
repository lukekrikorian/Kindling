//
//  Row.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import URLImage

struct BookRow: View {
	@EnvironmentObject var store: Store
	var book: Book
	var body: some View {
		HStack(alignment: .center) {
			BookRowImage(book: book)
			VStack(alignment: .leading) {
				Text((book.title ?? "Unknown Work").components(separatedBy: ":")[0])
					.font(.subheadline)
					.fontWeight(.semibold)
					.lineLimit(2)
				Text(book.author ?? "Unknown Author")
					.font(.subheadline)
					.lineLimit(1)
			}
			Spacer()
		}.padding([.top, .bottom], 15)
	}
}

struct BookRow_Previews: PreviewProvider {
	static var previews: some View {
		BookRow(book: PreviewContext.book)
			.modifier(PreviewWrapper())
			.frame(width: 300)
	}
}
