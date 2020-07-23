//
//  BookCover.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-29.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import FetchImage
import SwiftUI

struct BookCover: View {
	// TODO: Don't use PreviewContext for production builds
	var book: Book
	var placeholder: Image = PreviewContext.image
	var width: CGFloat = 40
	var height: CGFloat { width * 1.5 }

	var body: some View {
		ZStack {
			placeholder
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: self.width / 2)
			if book.coverURL != nil {
				FetchedImage(url: book.coverURL!)
			}
		}
//		.onAppear(perform: image.fetch)
//		.onDisappear(perform: image.cancel)
		.frame(width: width, height: height)
		.background(Color.secondary.opacity(0.3))
		.cornerRadius(3)
	}
}

struct FetchedImage: View {
	@ObservedObject var image: FetchImage
	init(url: String) {
		self.image = FetchImage(url: URL(string: url)!)
	}

	var body: some View {
		image.view?
			.resizable()
			.aspectRatio(contentMode: .fit)
	}
}

// struct BookRowImage_Previews: PreviewProvider {
//	static var previews: some View {
//		BookRowImage(book: PreviewContext.book)
//	}
// }

struct BookCover_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
