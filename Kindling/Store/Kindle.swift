//
//  Kindle.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-20.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Foundation

func GenerateKindleBooks() {
	var url = URL(string: "")

	if getBooksCount() < 1 {
		print("Didn't find any books in CoreData")
		#if DEBUG
		print("Generating books from /Users/luke/clippings.txt")
		url = URL(fileURLWithPath: "/Users/luke/clippings.txt")
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
		ParseTextClippings(from: textContents)
		try! context.save()
	}
}

func ParseClipping(_ input: String) -> (String, String, String) {
	let parts = input.regexpReplace(#"(\n|\r|\t|\|)"#, with: "\n")
		.components(separatedBy: "\n")
		.filter { $0 != "" }
		.map { $0.trimmingCharacters(in: .whitespaces) }

	let title = parts[0].regexpRemove(#"\(.+$"#)
	let author = parts[0].regexpRemove(#"(^.+\(|\))"#)
	let body = parts.last!.removeFootnotes()

	return (title, author, body)
}

func ParseTextClippings(from text: String) {
	print("Parsing clippings file")
	var clippings = text.components(separatedBy: "==========")
	_ = clippings.popLast()

	for clipping in clippings {
		let (title, author, body) = ParseClipping(clipping)
		AddNewClipping(title, author, body)
	}
	
	print("Finished parsing books...")
}

