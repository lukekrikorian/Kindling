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

	var body: some View {
		let isSelected = self.store.selectedClipping == self.clipping
		let background = isSelected ? Color.blue.opacity(0.6) : Color.black.opacity(0.0001)
		return HStack {
			Text(clipping.withLeadingCapital())
				.lineLimit(nil)
				.foregroundColor(isSelected ? Color.white : Color.primary)
				.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
				.font(.custom("Charter", size: 18))
				.contextMenu {
					ClippingContextMenu(clipping: self.clipping)
				}
			Spacer()
		}
		.background(background)
		.cornerRadius(3)
		.onTapGesture {
			self.store.selectedClipping = isSelected ? nil : self.clipping
		}
	}
}

struct ClippingContextMenu: View {
	@EnvironmentObject var store: Store
	var clipping: Clipping

	var body: some View {
		Group {
			Button(action: { self.copyQuote(.plain) }) {
				Text("Copy Quote")
			}
			Button(action: { self.copyQuote(.citation) }) {
				Text("Copy Quote with Citation")
			}
			Button(action: self.deleteClipping) {
				Text("Delete Highlight")
			}
		}
	}

	func copyQuote(_ type: QuoteType) {
		let clip = self.clipping.as(type, from: self.store.selectedBook)
		pasteboard.clearContents()
		pasteboard.writeObjects([clip as NSString])
	}

	func deleteClipping() {
		guard let index = self.store.selectedBook!.clippings!.firstIndex(of: self.clipping) else { return }
		self.store.selectedBook!.clippings?.remove(at: index)
	}
}

struct ClippingView_Previews: PreviewProvider {
	static var previews: some View {
		ClippingView(clipping: PreviewContext.book.clippings![0])
			.frame(width: 500)
			.environmentObject(Store())
	}
}
