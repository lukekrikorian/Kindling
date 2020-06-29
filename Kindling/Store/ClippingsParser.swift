//
//  ClippingsParser.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-20.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
var BookDescription = NSEntityDescription.entity(forEntityName: "Book", in: context)!

func getBooksCount() -> Int {
	let req: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()

	#if FORCE_RELOAD_BOOK_DATA
	print("Force reloading book data")
	let deleteRequest = NSBatchDeleteRequest(fetchRequest: req)
	try! context.execute(deleteRequest)
	#endif

	req.includesPropertyValues = false
	do { try context.fetch(req) } catch { print(error) }
	let count = (try! context.fetch(req)).count
	return count
}

func GenerateBooks() {
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

struct iTunesBook: Decodable {
	let trackName: String
	let artistName: String
	let genres: [String]
	let artworkUrl100: String
	let description: String
	let artistViewUrl: String
}

struct SearchResults: Decodable {
	let resultCount: Int
	let results: [iTunesBook]
}

func ParseClipping(clipping input: String) -> (String, String, String) {
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
	var books: [Book] = []
	var clippings = text.components(separatedBy: "==========")
	_ = clippings.popLast()

	for clip in clippings {
		let (title, _, body) = ParseClipping(clipping: clip)
		let index = books.firstIndex(where: { $0.title == title })

		if index != nil {
			books[index!].clippings!.append(body)
		} else {
			let itunesBook = GetiTunesBook(from: title)
			let book = Book(context: context)
			book.title = title
			book.author = itunesBook.artistName
			book.clippings = [body]
			book.id = UUID()
			book.authorURL = itunesBook.artistViewUrl
			book.coverURL = itunesBook.artworkUrl100.regexpReplace("100x100bb", with: "0x200h")
			books.append(book)
		}
	}
}

func GetiTunesBook(from title: String) -> iTunesBook {
	let URLSafeTitle = title.components(separatedBy: ":").first!
		.components(separatedBy: " ")
		.map { $0.regexpRemove(#"[^\w]"#) }
		.joined(separator: "+")

	let searchURL = URL(string: "https://itunes.apple.com/search?term=\(URLSafeTitle)&entity=ebook")!
	let request = URLRequest(url: searchURL)

	let (data, _, _) = URLSession.shared.synchronousTask(request)
	let searchResults = try! JSONDecoder().decode(SearchResults.self, from: data!)

	return searchResults.results[0]
}
