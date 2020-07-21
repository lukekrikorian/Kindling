//
//  BookCover.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-29.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import URLImage

struct BookCover: View {
	@ObservedObject var book: Book
	var placeholder: Image
	var width: CGFloat = 40
	var height: CGFloat { width * 1.5 }
	
	var body: some View {
		let url: URL? = URL(string: self.book.coverURL ?? "")
		let hasImage = (url != nil)
		return Group {
			if hasImage {
				URLImage(url!, placeholder: self.placeholder) {
					$0.image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.cornerRadius(3)
				}
			} else {
				placeholder
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 20)
			}
		}
		.saturation(hasImage ? 0.9 : 0.4)
		.frame(width: self.width, height: self.height)
		.background(hasImage ? Color.clear : Color.secondary.opacity(0.3))
		.cornerRadius(3)
		
	}
}

//struct BookRowImage_Previews: PreviewProvider {
//	static var previews: some View {
//		BookRowImage(book: PreviewContext.book)
//	}
//}

struct BookCover_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
