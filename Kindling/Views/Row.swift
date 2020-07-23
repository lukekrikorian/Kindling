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
	@ObservedObject var book: Book
	var body: some View {
		HStack(alignment: .center) {
			BookCover(book: book)
			VStack(alignment: .leading) {
				Text((book.title).components(separatedBy: ":")[0])
					.font(.subheadline)
					.fontWeight(.semibold)
					.lineLimit(2)
				Text(book.author)
					.font(.subheadline)
					.lineLimit(1)
//				Text("\(book.clippings.count) highlights")
//					.font(.footnote)
//					.lineLimit(1)
//					.foregroundColor(Color.secondary)
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
