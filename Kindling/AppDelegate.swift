//
//  AppDelegate.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa
import SwiftUI

var store = Store()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBAction func MenuActionUndo(_ sender: Any) {
		context.undo()
	}

	@IBAction func MenuActionRedo(_ sender: Any) {
		context.redo()
	}

	@IBAction func MenuActionSave(_ sender: Any) {
		do { try context.save() }
		catch { print("Failed to save!") }
	}

	@IBAction func MenuActionDelete(_ sender: Any) {
		guard store.selectedBook != nil else { return }
		store.selectedBook!.delete()
	}

	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Book")
		container.loadPersistentStores(completionHandler: { _, error in
			if let error = error {
				fatalError("Unresolved error \(error)")
			}
        })
		return container
	}()

	func applicationDidFinishLaunching(_ obj: Notification) {
		context.undoManager = CoreData.UndoManager()
	}

	func applicationWillTerminate(_ obj: Notification) {
		try! context.save()
	}
}

class WindowController: NSWindowController {
	override func windowDidLoad() {
		let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		var contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(store)
		window?.contentView = NSHostingView(rootView: contentView)
		var frame = window?.frame
		frame?.size = NSMakeSize(850, 550)
		window?.setFrame(frame!, display: false)
		window?.makeKeyAndOrderFront(nil)
	}
}

class SearchFieldHandler: NSSearchField {
	func updateStore() {
		store.searchQuery = stringValue.trimmingCharacters(in: .whitespaces)
	}

	override func textDidChange(_ notification: Notification) {
		updateStore()
	}

	override func textDidEndEditing(_ notification: Notification) {
		updateStore()
	}
}
