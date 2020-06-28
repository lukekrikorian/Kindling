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

	@Published var selectedBook: Book?
	@Published var selectedClipping: Clipping? {
		willSet(selection) {
			DispatchQueue.main.async {
				var toolbar = NSApplication.shared.mainWindow!.toolbar!
				var shareButton = toolbar.items.first(where: { $0.itemIdentifier == .shareButton })
				shareButton?.isEnabled = (selection != nil)
			}
		}
	}

	init() { GenerateBooks() }
}
