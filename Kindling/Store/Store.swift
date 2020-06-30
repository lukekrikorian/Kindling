//
//  Store.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-18.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
	@Published var searchQuery: String = "" {
		willSet {
			self.selectedClipping = nil
		}
	}

	@Published var selectedBook: Book? {
		willSet {
			self.selectedClipping = nil
		}
	}

	@Published var selectedClipping: Clipping? {
		willSet {
			self.validateShareButtons()
		}
	}

	private func validateShareButtons() {
		DispatchQueue.main.async {
			let shouldEnable = self.selectedClipping != nil
			
			let toolbar = NSApplication.shared.mainWindow?.toolbar
			let toolbarItem = toolbar!.items.first(where: {
				$0.itemIdentifier == .shareButton
			})
			toolbarItem?.isEnabled = shouldEnable
			
			TouchBarItems.ShareButton.isEnabled = shouldEnable
		}
	}

	public func selectedClippingFormat(_ format: QuoteType) -> String {
		let book = self.selectedBook!
		let clipping = self.selectedClipping!.withLeadingCapital()
		switch format {
			case .citation:
				return "\u{201c}\(clipping)\u{201d} \(book.author!), \(book.title!)"
			case .normal:
				return clipping
		}
	}
}
