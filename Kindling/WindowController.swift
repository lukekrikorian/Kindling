//
//  WindowController.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-06-27.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa
import SwiftUI

class WindowController: NSWindowController {
	@IBAction func ToolbarActionShare(_ sender: NSButton) {
		let citation = store.selectedBook?.selectedClippingCitation(.citation)
		let ServicePicker = NSSharingServicePicker(items: [citation ?? ""])
		ServicePicker.show(relativeTo: NSZeroRect, of: sender, preferredEdge: .minY)
	}

	override func windowDidLoad() {
		let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		let contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(store)
		window?.contentView = NSHostingView(rootView: contentView)
		var frame = window?.frame
		frame?.size = NSMakeSize(850, 550)
		window?.setFrame(frame!, display: false)
		window?.makeKeyAndOrderFront(nil)
		DispatchQueue.main.async { GenerateBooks() }
	}
}
