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
	var req: FetchRequest<Clipping>
	@State private var sheetToggle = false
	@State private var sortToggle = false
	@State private var sort: ClippingSort = .page

	init(book: Book) {
		UITableView.appearance().separatorStyle = .none
		self.book = book
		self.req = FetchRequest(entity: Clipping.entity(), sortDescriptors: [
			NSSortDescriptor(keyPath: \Clipping.page, ascending: true)
		], predicate: NSPredicate(format: "book.title = %@", book.title))
	}

	var body: some View {
		List {
			Group {
				BookHeader(book: book)
				ForEach(req.wrappedValue, id: \.self.id) { clipping in
					ClippingView(clipping: clipping)
				}
			}
			.listRowInsets(EdgeInsets())
			.padding(5)
		}
		.navigationBarTitle(Text(""), displayMode: .inline)
		.navigationBarItems(trailing: HStack {
			sortButton
			addButton
		})
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
