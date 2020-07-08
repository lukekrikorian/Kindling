//
//  Toolbar.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-27.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa
import SwiftUI

extension NSToolbarItem.Identifier {
	static let searchField = NSToolbarItem.Identifier(rawValue: "Search Field")
	static let shareButton = NSToolbarItem.Identifier(rawValue: "Share Button")
}

extension WindowController {
	@IBAction func ToolbarActionAddClipping(_ sender: NSButton) {
		self.clippingWindow = NSWindow(
			contentRect: .zero,
			styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
			backing: .buffered,
			defer: false)
		let view = NewClipping(window: self.clippingWindow)

		self.clippingWindow.contentView = NSHostingView(rootView: view)
		self.clippingWindow.center()
		self.clippingWindow.makeKeyAndOrderFront(nil)
	}

	@IBAction func ToolbarActionShare(_ sender: NSButton) {
		let citation = store.selectedClipping?.as(.citation, from: store.selectedBook)
		let ServicePicker = NSSharingServicePicker(items: [citation ?? "Nothing to share"])
		ServicePicker.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
	}
}

class SearchFieldController: NSSearchField {
	func updateSearchQuery() {
		store.searchQuery = stringValue.trimmingCharacters(in: .whitespaces)
	}

	override func textDidChange(_ notification: Notification) {
		if stringValue == "" {
			self.updateSearchQuery()
		}
	}

	override func textDidEndEditing(_ notification: Notification) {
		self.updateSearchQuery()
	}
}
