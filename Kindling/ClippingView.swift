//
//  ClippingView.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

enum QuoteType {
	case quote, citation
}

struct ClippingView: View {
	@EnvironmentObject var store: Store
	var clipping: Clipping
	let pasteboard = NSPasteboard.general

	var body: some View {
		Text(clipping.withLeadingCapital())
			.lineLimit(nil)
			.padding(.bottom)
			.font(.custom("Charter", size: 17))
			.contextMenu {
				Button(action: { self.copyQuote(type: .quote) }) {
					Text("Copy Quote")
				}
				Button(action: { self.copyQuote(type: .citation) }) {
					Text("Copy Quote with Citation")
				}
				Button(action: { /* self.showModal(clipping) */ }) {
					Text("Edit")
				}
			}
	}

	func copyQuote(type: QuoteType) {
		var clip: String = self.clipping
		var book = self.store.selectedBook!
		if type == .citation {
			clip = "\u{201c}\(self.clipping)\u{201d} \(book.author!), \(book.title!)"
		}
		self.pasteboard.clearContents()
		self.pasteboard.writeObjects([clip as NSString])
	}
}

struct ClippingView_Previews: PreviewProvider {
	static var previews: some View {
		ClippingView(clipping: "Hello there!")
	}
}
