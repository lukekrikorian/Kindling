//
//  AppDelegate.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Book")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func applicationDidFinishLaunching(_ obj: Notification) { }
    func applicationWillTerminate(_ obj: Notification) { }
}

var store = Store()

class WindowController: NSWindowController {
    override func windowDidLoad() {
        let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var contentView = ContentView().environment(\.managedObjectContext, context).environmentObject(store)
        window?.contentView = NSHostingView(rootView: contentView)
        window?.makeKeyAndOrderFront(nil)
    }
}

class SearchFieldHandler: NSSearchField {
    override func textDidChange(_ notification: Notification) {
        store.searchQuery = self.stringValue
    }
	override func textDidEndEditing(_ notification: Notification) {
		store.searchQuery = self.stringValue
	}
}

