//
//  Clipping.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-10.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

enum Sheet {
	case share, edit
}

struct ClippingView: View {
	@Environment(\.managedObjectContext) var context
	var clipping: Clipping
	@State var showSheet = false
	@State var sheet: Sheet?

	var contextMenu: some View {
		Group {
			Button(action: {
				self.sheet = .share
				self.showSheet = true
			}) {
				Text("Share")
				Image(uiImage: UIImage(systemName: "square.and.arrow.up")!)
			}
			Button(action: {
				self.sheet = .edit
				self.showSheet = true
			}) {
				Text("Edit")
				Image(uiImage: UIImage(systemName: "text.insert")!)
			}
			Button(action: { self.context.delete(self.clipping) }) {
				Text("Delete")
				Image(uiImage: UIImage(systemName: "trash")!)
			}
		}
	}

	var body: some View {
		ClippingText(clipping: clipping)
			.contextMenu { contextMenu }
			.sheet(isPresented: self.$showSheet, content: {
				if self.sheet == .share {
					ActivityView(items: [self.clipping.text])
				} else {
					ClippingForm(type: .edit, sheetBinding: self.$showSheet, clipping: self.clipping)
					.environment(\.managedObjectContext, self.context)
				}
			})
	}
}

struct ClippingView_Previews: PreviewProvider {
	static var previews: some View {
		ClippingView(clipping: PreviewContext.book.clippings.first!)
	}
}
