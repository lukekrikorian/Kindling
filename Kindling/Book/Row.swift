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
	var Book: Book
	var body: some View {
		HStack(alignment: .center) {
			BookRowImage(Book: Book)
			VStack(alignment: .leading) {
				Text(Book.title!.components(separatedBy: ":")[0])
					.font(.subheadline)
					.fontWeight(.semibold)
					.lineLimit(2)
				Text(Book.author!)
					.font(.subheadline)
					.lineLimit(1)
			}
			Spacer()
		}
		.contextMenu {
			Button(action: {
				context.delete(self.Book)
			}) {
				Text("Delete Book").foregroundColor(Color.red)
			}
		}
	}
}

struct BookRow_Previews: PreviewProvider {
	static var previews: some View {
		BookRow(Book: PreviewContext.book)
			.modifier(PreviewWrapper())
			.frame(width: 300)
	}
}
