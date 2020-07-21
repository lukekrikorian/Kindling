//
//  Store.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-18.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

class Store: ObservableObject {
	var bridge: Bridge = Bridge()
	@Published var searchQuery: String {
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
			#if !os(iOS)
			self.updateShareButtons(enabled: clipping != nil)
			#endif
		}
	}
	
	init() { self.searchQuery = "" }
}
