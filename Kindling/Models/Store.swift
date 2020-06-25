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
	@Published var selectedClipping: String?

	init() { GenerateBooks() }
}
