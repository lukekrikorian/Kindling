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
		return ClippingText(clipping: clipping)
			.foregroundColor(isSelected ? Color.white : Color.primary)
			.background(background)
			.contextMenu { ClippingContextMenu(clipping: clipping) }
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
			Button("Copy Quote", action: { self.copyQuote(.plain) })
			Button("Copy Quote with Citation", action: { self.copyQuote(.citation) })
			Button("Delete Highlight", action: self.deleteClipping)
		}
	}

	func copyQuote(_ type: QuoteType) {
		let clip = self.clipping.as(type)
		self.store.bridge.saveToClipboard(str: clip)
	}

	func deleteClipping() {
		guard let index = self.store.selectedBook!.clippings.firstIndex(of: self.clipping) else { return }
		self.store.selectedBook!.clippings.remove(at: index)
	}
}

struct ClippingView_Previews: PreviewProvider {
	static var previews: some View {
		ClippingView(clipping: PreviewContext.book.clippings.first!)
			.frame(width: 500)
			.environmentObject(Store())
	}
}
