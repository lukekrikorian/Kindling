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
	var Book: Book
	var body: some View {
		URLImage(URL(string: self.Book.coverURL!)!, placeholder: { _ in
			Color.clear
				.frame(width: 70, height: 100)
			}) { proxy in
			proxy.image
				.resizable()
				.aspectRatio(contentMode: .fit)
				.cornerRadius(3)
				.saturation(0.9)
				.frame(width: 45, height: 100)
		}
	}
}

struct BookRowImage_Previews: PreviewProvider {
	static var previews: some View {
		BookRowImage(Book: PreviewContext.book)
	}
}
