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
var PreviewContext = Preview()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBAction func MenuActionUndo(_ sender: Any) {
		self.persistentContainer.viewContext.undo()
	}

	@IBAction func MenuActionRedo(_ sender: Any) {
		self.persistentContainer.viewContext.redo()
	}

	@IBAction func MenuActionSave(_ sender: Any) {
		do { try self.persistentContainer.viewContext.save() }
		catch { print("Failed to save!") }
	}

	@IBAction func MenuActionDelete(_ sender: Any) {
		guard store.selectedBook != nil else { return }
		self.persistentContainer.viewContext.delete(store.selectedBook!)
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
		self.persistentContainer.viewContext.undoManager = CoreData.UndoManager()
	}

	func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
		print("Saving CoreData before termination")
		do { try self.persistentContainer.viewContext.save() } catch { print(error) }
		print("Terminating Application")
		return .terminateNow
	}
}
