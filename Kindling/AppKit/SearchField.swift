//
//  SearchField.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-07.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct SearchField: NSViewRepresentable {
	@Binding var text: String
	func makeNSView(context: Context) -> NSSearchField {
		var field = NSSearchField()
		field.placeholderString = "Search Highlights"
		field.delegate = context.coordinator
		return field
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, NSSearchFieldDelegate {
		let parent: SearchField
		init(_ parentView: SearchField) {
			self.parent = parentView
		}

		func controlTextDidChange(_ notification: Notification) {
			guard let field = notification.object as? NSSearchField else { return }
			self.parent.text = field.stringValue
		}

		func searchFieldDidEndSearching(_ sender: NSSearchField) {
			self.parent.text = sender.stringValue
		}
	}

	func updateNSView(_ SearchField: NSSearchField, context: Context) {
		SearchField.stringValue = self.text
	}
}

struct Search_Previews: PreviewProvider {
	static var previews: some View {
		SearchField(text: .constant(""))
	}
}
