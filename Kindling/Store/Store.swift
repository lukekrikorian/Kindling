//
//  Store.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-18.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
	@Published var searchQuery: String? {
		willSet {
			self.selectedBook = nil
		}
	}

	@Published var selectedBook: Book? {
		willSet {
			self.selectedClipping = nil
		}
	}

	@Published var selectedClipping: Clipping? {
		willSet(clipping) {
			self.updateShareButtons(enabled: clipping != nil)
		}
	}
}

extension Store {
	private func updateShareButtons(enabled: Bool) {
		let toolbar = NSApplication.shared.mainWindow?.toolbar
		let toolbarItem = toolbar?.items.first(where: {
			$0.itemIdentifier == .shareButton
		})

		toolbarItem?.isEnabled = enabled
		TouchBarItems.ShareButton.isEnabled = enabled
	}
}
