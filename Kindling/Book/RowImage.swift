//
//  RowImage.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-29.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import URLImage

struct BookRowImage: View {
	var book: Book
	var url: URL? { URL(string: self.book.coverURL ?? "") }

	var body: some View {
		let hasImage = !(self.url == nil)
		return Group {
			if hasImage {
				URLImage(url!, placeholder: { _ in Color.clear }) {
					$0.image
						.resizable()
						.aspectRatio(contentMode: .fit)
				}
			} else {
				Image(nsImage: NSImage(named: NSImage.touchBarBookmarksTemplateName)!)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 20)
			}
		}
		.saturation(hasImage ? 0.9 : 0.4)
		.frame(width: 45)
		.cornerRadius(3)
		.background(hasImage ? Color.clear : Color.secondary.opacity(0.3))
	}
}

struct BookRowImage_Previews: PreviewProvider {
	static var previews: some View {
		BookRowImage(book: PreviewContext.book)
	}
}
