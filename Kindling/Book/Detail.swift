//
//  Detail.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-20.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import URLImage

struct BookDetail: View {
	@FetchRequest(entity: BookDescription, sortDescriptors: []) var books: FetchedResults<Book>
	@EnvironmentObject var store: Store
	var Book: Book
	var body: some View {
		let clippings = self.Book.clippings!.filteredBy(self.store.searchQuery ?? "")
		return ScrollView {
			HStack {
				Spacer()
				VStack(alignment: .leading) {
					BookHeader(book: Book)
					ForEach(clippings, id: \.self) { clipping in
						ClippingView(clipping: clipping)
					}
				}.frame(maxWidth: 700)
				Spacer()
			}
		}
		.frame(minWidth: 300)
	}
}

struct BookDetail_Previews: PreviewProvider {
	static var previews: some View {
		BookDetail(Book: PreviewContext.book)
			.modifier(PreviewWrapper())
			.frame(width: 500, height: 400)
	}
}
