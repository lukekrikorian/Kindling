//
//  Clipping.swift
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
		let isSelected = self.store.selectedClipping == self.clipping
		return HStack {
			Text(clipping.withLeadingCapital())
				.lineLimit(nil)
				.foregroundColor(isSelected ? Color.white : Color.primary)
				.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
				.font(.custom("Charter", size: 18))
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
				}
				.onTapGesture {
					self.store.selectedClipping = isSelected ? nil : self.clipping
				}
			Spacer()
		}.background(isSelected ? Color.blue.opacity(0.6) : Color.clear)
	}

	func copyQuote(_ type: QuoteType) {
		let clip = self.store.selectedClippingFormat(type)
		self.pasteboard.clearContents()
		self.pasteboard.writeObjects([clip as NSString])
	}

	func deleteClipping() {
		let book = self.store.selectedBook!
		let index = book.clippings!.index(of: self.clipping)
		book.clippings!.remove(at: index)
	}
}

struct ClippingView_Previews: PreviewProvider {
	static var previews: some View {
		ClippingView(clipping: "It has resolved personal worth into exchange value, and in place of the numberless indefeasible chartered freedoms, has set up that single, unconscionable freedom—Free Trade. In one word, for exploitation, veiled by religious and political illusions, it has substituted naked, shameless, direct, brutal exploitation.")
			.frame(width: 500)
			.environmentObject(Store())
	}
}
