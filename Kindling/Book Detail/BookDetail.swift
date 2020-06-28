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
		var clippings = self.Book.clippings!.filtered(by: self.store.searchQuery)
		return ScrollView {
			VStack(alignment: .leading) {
				Group {
					// TODO: Fix title padding here
					Text(self.Book.title!)
						.font(.title)
						.fontWeight(.semibold)
						.lineLimit(nil)
					Button(action: self.openAuthorURL) {
						Text(self.Book.author!)
					}.buttonStyle(LinkButtonStyle()).padding(.top, -15)
					Divider()
				}.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
				ForEach(clippings, id: \.self) { clipping in
					ClippingView(clipping: clipping)
				}.frame(maxWidth: .infinity)
			}
		}.frame(minWidth: 300).onAppear(perform: self.clearSelectedClipping)
	}
	
	func clearSelectedClipping() {
		self.store.selectedClipping = nil
	}
	
	func openAuthorURL() {
		var authorUrl = URL(string: self.Book.authorURL!)!
		NSWorkspace.shared.open(authorUrl)
	}
}

// struct BookDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BookDetail(book: nil, SearchQuery: "capitalism", EditModal: Binding.constant((false, ""))).frame(width: 700, height: 400)
//    }
// }
