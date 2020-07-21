//
//  Kindle.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-20.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData

func AddKindleBooks(to context: NSManagedObjectContext) {
	var url = URL(string: "")

	if getBooksCount(from: context) < 1 {
		print("Didn't find any books in CoreData")
		#if DEBUG
		print("Generating books from bundle clipping file")
		url = Bundle.main.url(forResource: "clippings", withExtension: "txt")
		#else
		print("Generating books from NSOpenPanel")
		var dialog = NSOpenPanel()

		dialog.canChooseDirectories = false
		dialog.showsHiddenFiles = false
		dialog.allowedFileTypes = ["txt"]
		if dialog.runModal() == NSApplication.ModalResponse.OK {
			url = dialog.url!
		}
		#endif
		let textContents: String = try! String(contentsOf: url!)
		ParseTextClippings(to: context, from: textContents)
		try! context.save()
	}
}

func ParseClipping(_ input: String) -> (String, String, String, Int) {
	let parts = input.regexpReplace(#"(\n|\r|\t|\|)"#, with: "\n")
		.components(separatedBy: "\n")
		.filter { $0 != "" }
		.map { $0.trimmingCharacters(in: .whitespaces) }

	let title = parts[0].regexpRemove(#"\(.+$"#)
	let author = parts[0].regexpRemove(#"(^.+\(|\))"#)
	let body = parts.last!.removeFootnotes()
	let page = Int(parts[1].regexpRemove(#".+page "#)) ?? 0
	
	return (title, author, body, page)
}

func ParseTextClippings(to context: NSManagedObjectContext, from text: String) {
	print("Parsing clippings file")
	var clippings = text.components(separatedBy: "==========")
	_ = clippings.popLast()

	for clipping in clippings {
		let (title, author, body, page) = ParseClipping(clipping)
		AddNewClipping(to: context, title, author, body, Int16(page))
	}
	
	print("Finished parsing books...")
}

