//
//  ClippingForm.swift
//  iOSKindling
//
//  Created by Luke Krikorian on 2020-07-13.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI
import TextView

enum FormType {
	case new, newInBook, edit
}

struct ClippingForm: View {
	@Environment(\.managedObjectContext) var context

	var type: FormType

	@Binding var sheetBinding: Bool
	
	@State var author = ""
	@State var title = ""
	@State var text: String = ""
	
	@State var page: Int16 = 0
	@State var stringPage = ""
	
	@State var isEditing: Bool = false

	var clipping: Clipping?

	var isValid: Bool {
		self.text.count > 0 && (self.title.count + self.author.count > 0)
	}

	var body: some View {
		Form {
			Section(header:
				HStack {
					Text(self.type != .edit ? "Add Highlight" : "Edit Highlight")
						.font(.largeTitle)
						.foregroundColor(.white)
						.fontWeight(.bold)
						.padding(.top)
					Spacer()
					Button("Save", action: self.saveClipping)
						.disabled(!self.isValid)
						.font(.body)
				}

			) { EmptyView() }

			Section(header: Text("BOOK")) {
				TextField("Title", text: self.$title)
					.disabled(self.type != .new)
				TextField("Author", text: self.$author)
					.disabled(self.type != .new)
			}

			Section(header: Text("HIGHLIGHT")) {
				TextField("Page", text: self.$stringPage)
					.keyboardType(.numberPad)
				TextView(text: self.$text, isEditing: self.$isEditing, placeholder: "Highlight")
					.padding(.leading, -5)
					.frame(height: 200)
			}
		}
		.onAppear {
			self.stringPage = self.page > 0 ? String(self.page) : ""
			if let clipping = self.clipping {
				self.author = clipping.book.author
				self.text = clipping.text
				self.title = clipping.book.title
			}
		}
	}

	func saveClipping() {
		if self.type == .edit {
			self.context.delete(self.clipping!)
		}
		AddNewClipping(to: self.context, self.title, self.author, self.text, Int16(self.stringPage) ?? 0)
		self.sheetBinding = false
	}
}

struct ClippingForm_Previews: PreviewProvider {
	static var previews: some View {
		ClippingForm(type: .new, sheetBinding: .constant(false))
	}
}
