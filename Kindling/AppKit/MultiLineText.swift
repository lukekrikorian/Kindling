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
    var x: Int = 100
    var y: Int = 100
    var scrollable: Bool = true
    var editable: Bool = true
    var textView = NSTextView()
    func makeNSView(context: Context) -> NSScrollView {
        var scrollViewSize = NSRect(origin: .zero, size: CGSize(width: x, height: y))
        var scrollView = NSScrollView(frame: scrollViewSize)
        scrollView.frame = scrollViewSize
        scrollView.hasVerticalScroller = scrollable
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.documentView = textView
        scrollView.backgroundColor = NSColor.controlBackgroundColor
        textView.frame = scrollView.frame
        textView.isEditable = editable
        textView.isSelectable = true
        textView.isRichText = false
        textView.font = NSFont.init(name: "Charter", size: 16 as CGFloat)!
        textView.backgroundColor = NSColor.controlBackgroundColor
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
            self.parent.text = textView.string
        }
    }
    
    func updateNSView(_ ScrollView: NSScrollView, context: Context) {
        textView.string = text
    }
}

struct MultiLineText_Previews: PreviewProvider {
    static var previews: some View {
        MultiLineText(text: Binding.constant("Lol!"), x: 100, y: 100)
    }
}
