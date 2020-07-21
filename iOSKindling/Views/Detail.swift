//
//  Detail.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import UIKit
import URLImage

enum ClippingSort {
	case page, date
}

struct BookDetail: View {
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var store: Store
	@ObservedObject var book: Book

	@State private var sheetToggle = false
	
	@State private var sortToggle = false
	@State private var sort: ClippingSort = .page

	var body: some View {
		let clippings = self.book.filteredClippings(by: self.store.searchQuery).sorted(by: {
			switch self.sort {
				case .date:
					return $0.date < $1.date
				case .page:
					return $0.page < $1.page
			}
		})
		return ScrollView {
			HStack {
				Spacer()
				VStack(alignment: .leading) {
					BookHeader(book: book)
					ForEach(Array(clippings), id: \.self.id) { clipping in
						ClippingView(clipping: clipping)
					}
				}
				Spacer()
			}
		}
		.navigationBarTitle(Text(""), displayMode: .inline)
		.navigationBarItems(trailing: HStack {
			sortButton
			addButton
		}
		)
		.actionSheet(isPresented: self.$sortToggle) {
			ActionSheet(title: Text("Sort Highlights"), buttons: [
				.default(Text("By Date Added")) { self.sort = .date },
				.default(Text("By Page")) { self.sort = .page },
				.cancel()
			])
		}
		.sheet(isPresented: self.$sheetToggle) {
			ClippingForm(type: .newInBook, sheetBinding: self.$sheetToggle, author: self.book.author, title: self.book.title)
				.environment(\.managedObjectContext, self.context)
		}
		.frame(minWidth: 300)
	}

	var sortButton: some View {
		Button(action: { self.sortToggle = true }) {
			Image(uiImage: UIImage(systemName: "arrow.up.arrow.down.circle.fill")!)
				.imageScale(.large)
		}
	}

	var addButton: some View {
		Button(action: { self.sheetToggle = true }) {
			Image(uiImage: UIImage(systemName: "plus.circle.fill")!)
				.imageScale(.large)
		}
	}
}

struct BookDetail_Previews: PreviewProvider {
	static var previews: some View {
		BookDetail(book: PreviewContext.book)
			.modifier(PreviewWrapper())
	}
}
