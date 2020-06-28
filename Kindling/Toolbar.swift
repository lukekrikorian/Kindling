//
//  Toolbar.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-27.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa

extension NSToolbarItem.Identifier {
	static let shareButton = NSToolbarItem.Identifier(rawValue: "ShareButton")
}

class SearchFieldController: NSSearchField {
	func updateSearchQuery() {
		store.searchQuery = stringValue.trimmingCharacters(in: .whitespaces)
	}

	override func textDidChange(_ notification: Notification) {
		updateSearchQuery()
	}

	override func textDidEndEditing(_ notification: Notification) {
		updateSearchQuery()
	}
}