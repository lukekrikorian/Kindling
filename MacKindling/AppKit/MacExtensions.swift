//
//  macOS.swift
//  MacKindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa

extension Store {
	public func updateShareButtons(enabled: Bool) {
		let toolbar = NSApplication.shared.mainWindow?.toolbar
		let toolbarItem = toolbar?.items.first(where: {
			$0.itemIdentifier == .shareButton
		})

		toolbarItem?.isEnabled = enabled
		TouchBarItems.ShareButton.isEnabled = enabled
	}
}

extension NSTextField {
	override open var focusRingType: NSFocusRingType {
		get { .none }
		set {}
	}
}
