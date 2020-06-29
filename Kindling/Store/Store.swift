//
//  Store.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-18.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
	@Published var searchQuery: String = ""

	@Published var selectedBook: Book? {
		willSet(book) {
			self.selectedClipping = nil
		}
	}

	@Published var selectedClipping: Clipping? {
		willSet(clipping) {
			DispatchQueue.main.async {
				let toolbar = NSApplication.shared.mainWindow?.toolbar
				guard toolbar != nil else { return }
				let shareButton = toolbar!.items.first(where: { $0.itemIdentifier == .shareButton })
				shareButton?.isEnabled = (clipping != nil)
			}
		}
	}
}
