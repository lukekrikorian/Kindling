//
//  MultiLineText.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-24.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

struct MultiLineText: NSViewRepresentable {
	@Binding var text: String
	var fontSize: Int = 15
	var width: Int = 100
	var height: Int = 100
	var scrollable: Bool = true
	var editable: Bool = true
	let textView = NSTextView()
	func makeNSView(context: Context) -> NSScrollView {
		let scrollViewSize = NSRect(origin: .zero, size: CGSize(width: width, height: height))
		let scrollView = NSScrollView(frame: scrollViewSize)
		scrollView.frame = scrollViewSize
		scrollView.hasVerticalScroller = scrollable
		scrollView.hasHorizontalScroller = false
		scrollView.autohidesScrollers = true
		scrollView.drawsBackground = false
		scrollView.backgroundColor = NSColor.clear
		scrollView.documentView = textView
		textView.frame = scrollView.frame
		textView.isEditable = editable
		textView.isSelectable = true
		textView.isRichText = false
		textView.font = NSFont.systemFont(ofSize: CGFloat(self.fontSize))
		textView.backgroundColor = NSColor.clear
		textView.drawsBackground = false
		textView.delegate = context.coordinator
		return scrollView
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, NSTextViewDelegate {
		let parent: MultiLineText
		init(_ parentView: MultiLineText) {
			self.parent = parentView
		}

		func textDidChange(_ notification: Notification) {
			guard let textView = notification.object as? NSTextView else { return }
			parent.text = textView.string
		}
	}

	func updateNSView(_ ScrollView: NSScrollView, context: Context) {
		textView.string = text
	}
}

struct MultiLineText_Previews: PreviewProvider {
	static var previews: some View {
		MultiLineText(text: .constant("Lol!"), width: 100, height: 100).frame(width: 200, height: 300)
	}
}
