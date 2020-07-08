//
//  Header.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-28.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData
import SwiftUI

struct BookHeader: View {
	var book: Book
	var body: some View {
		VStack(alignment: .leading) {
			Text(self.book.title!)
				.font(.title)
				.fontWeight(.semibold)
				.lineLimit(nil)
			if self.book.authorURL != nil {
				Button(action: self.openAuthorURL) {
					Text(self.book.author!).font(.subheadline)
				}
				.buttonStyle(LinkButtonStyle())
				.padding(.top, -15)
			} else {
				Text(self.book.author!).font(.subheadline)
			}
			Divider()
		}.padding([.leading, .top, .trailing])
	}

	func openAuthorURL() {
		let authorUrl = URL(string: book.authorURL!)!
		NSWorkspace.shared.open(authorUrl)
	}
}

struct BookHeader_Previews: PreviewProvider {
	static var previews: some View {
		return BookHeader(book: PreviewContext.book)
			.modifier(PreviewWrapper())
			.frame(width: 400)
	}
}
