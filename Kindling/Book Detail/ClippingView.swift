//
//  ClippingView.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI



struct ClippingView: View {
	@EnvironmentObject var store: Store
	var clipping: Clipping
	let pasteboard = NSPasteboard.general

	var body: some View {
		var isSelected = self.store.selectedClipping == self.clipping
		return HStack {
			Text(clipping.withLeadingCapital())
				.lineLimit(nil)
				.foregroundColor(isSelected ? Color.white : Color.primary)
				.padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
				.font(.custom("Charter", size: 17))
				.contextMenu {
					Button(action: { self.copyQuote(.normal) }) {
						Text("Copy Quote")
					}
					Button(action: { self.copyQuote(.citation) }) {
						Text("Copy Quote with Citation")
					}
					Button(action: self.deleteClipping) {
						Text("Delete Highlight")
							.foregroundColor(Color.red)
					}
				}.onTapGesture {
					self.store.selectedClipping = isSelected ? nil : self.clipping
				}
			Spacer()
		}.background(isSelected ? Color.blue.opacity(0.6) : Color.clear)
	}

	func copyQuote(_ type: QuoteType) {
		var clip = store.selectedBook!.selectedClippingCitation(type)
		self.pasteboard.clearContents()
		self.pasteboard.writeObjects([clip as NSString])
	}

	func deleteClipping() {
		var book = self.store.selectedBook!
		var index = book.clippings!.index(of: self.clipping)
		book.clippings!.remove(at: index)
	}
}

struct ClippingView_Previews: PreviewProvider {
	static var previews: some View {
		ClippingView(clipping: "Hello there!")
	}
}
