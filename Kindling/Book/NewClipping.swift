//
//  NewClipping.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-03.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

enum ClippingType: String, CaseIterable, Identifiable {
	case book
	case webpage
	case other
	
	var id: String { self.rawValue }
}

struct NewClipping: View {
	var window: NSWindow?
	@State var author: String = ""
	@State var title: String = ""
	@State var type: ClippingType = .book
	@State var URL: String = ""
	@State var clipping: String = ""
	
	var body: some View {
		return Form {
			Section(header: Text("Add Highlight").font(.title).fontWeight(.bold)) {
				Divider()
				LabeledTextField(label: "\(self.type.rawValue.capitalized) Title",
								 placeholder: "Animal Farm",
								 bind: self.$title)
				
				Divider()
				LabeledTextField(label: "Author",
								 placeholder: "George Orwell",
								 bind: self.$author)
				
				Divider()
				HStack {
					Text("Highlight from:")
						.foregroundColor(.secondary)
					Picker("", selection: self.$type) {
						ForEach(ClippingType.allCases) { type in
							Text(type.rawValue.capitalized).tag(type)
						}
					}.labelsHidden().frame(width: 120)
					Spacer()
				}
				Divider()
				
				if self.type == .webpage {
					LabeledTextField(label: "URL", placeholder: "", bind: self.$URL)
					Divider()
				}
				
				MultiLineText(text: self.$clipping, width: 360)
			}.font(.subheadline)
			Spacer()
			Divider()
			HStack {
				Spacer()
				Button("Save", action: self.saveClipping)
					.disabled(self.isValid())
			}
		}.padding().frame(width: 400, height: 500)
	}
}

extension NewClipping {
	func isValid() -> Bool {
		return !(self.clipping.count > 0 && (self.author.count + self.title.count > 0))
	}
	
	func saveClipping() {
		AddNewClipping(self.title, self.author, self.clipping)
		self.window?.close()
	}
}

struct LabeledTextField: View {
	var label: String
	var placeholder: String
	@Binding var bind: String
	var body: some View {
		HStack {
			Text("\(self.label):")
				.foregroundColor(.secondary)
			TextField(self.placeholder, text: self.$bind)
				.textFieldStyle(PlainTextFieldStyle())
				.frame(maxWidth: .infinity)
			Spacer()
		}
	}
}

struct NewClipping_Previews: PreviewProvider {
	static var previews: some View {
		NewClipping(window: nil)
	}
}
