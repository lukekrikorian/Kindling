//
//  BookDetail.swift
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
		ScrollView {
			VStack(alignment: .leading) {
				Text(self.Book.title!)
					.font(.title)
					.fontWeight(.semibold)
					.lineLimit(nil)
					.padding(.bottom, -15)
				Button(action: {
					var authorUrl = URL(string: self.Book.authorURL!)!
					NSWorkspace.shared.open(authorUrl)
				}) { Text(self.Book.author!) }
					.buttonStyle(LinkButtonStyle())
					.padding(0)
				Divider()
				ForEach(self.Book.clippings!.filtered(by: self.store.searchQuery), id: \.self) { clipping in
					ClippingView(clipping: clipping)
				}
			}
			.frame(minWidth: 300)
			.padding()
		}
	}
}

// struct BookDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BookDetail(book: nil, SearchQuery: "capitalism", EditModal: Binding.constant((false, ""))).frame(width: 700, height: 400)
//    }
// }
