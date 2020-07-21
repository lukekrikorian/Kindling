//
//  TouchBar.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-29.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
	static let share = NSTouchBarItem.Identifier(rawValue: "Share Button")
	static let search = NSTouchBarItem.Identifier(rawValue: "Search Button")
}

public struct TouchBarItems {
	static let ShareButton = NSSharingServicePickerTouchBarItem(identifier: .share)
	static let SearchButton = NSCustomTouchBarItem(identifier: .search)
}

extension WindowController: NSTouchBarDelegate {
	override func makeTouchBar() -> NSTouchBar? {
		let touchBar = NSTouchBar()
		touchBar.delegate = self
		touchBar.defaultItemIdentifiers = [.share, .search]
		return touchBar
	}

	@objc func TouchBarActionSearch() {
		let searchField = self.window?.toolbar?.items.first(where: {
			$0.itemIdentifier == .searchField
		})?.view as? NSSearchField
		searchField?.becomeFirstResponder()
	}

	func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
		switch identifier {
			case .share:
				let item = TouchBarItems.ShareButton
				item.delegate = self
				item.isEnabled = false
				return item
			case .search:
				let item = TouchBarItems.SearchButton
				let searchImage = NSImage(named: NSImage.touchBarSearchTemplateName)!
				item.view = NSButton(image: searchImage, target: self, action: #selector(self.TouchBarActionSearch))
				return item
			default: return nil
		}
	}
}

extension WindowController: NSSharingServicePickerTouchBarItemDelegate {
	func items(for pickerTouchBarItem: NSSharingServicePickerTouchBarItem) -> [Any] {
		return [store.selectedClipping?.as(.citation) ?? "No Clipping"]
	}
}
