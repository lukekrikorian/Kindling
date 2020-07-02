//
//  Store.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-18.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
	@Published var listSelection: Book? {
		willSet(book) {
			self.selectedBook = book
		}
	}

	@Published var searchQuery: String? {
		willSet(query) {
			self.selectedBook = nil
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
}

extension Store {
	private func validateShareButtons() {
		DispatchQueue.main.async {
			let shouldEnable = self.selectedClipping != nil

			let toolbar = NSApplication.shared.mainWindow?.toolbar
			let toolbarItem = toolbar?.items.first(where: {
				$0.itemIdentifier == .shareButton
			})
			toolbarItem?.isEnabled = shouldEnable

			TouchBarItems.ShareButton.isEnabled = shouldEnable
		}
	}
}
