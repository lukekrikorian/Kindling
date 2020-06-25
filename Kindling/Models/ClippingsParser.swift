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

func getBooks(withProperties: Bool) -> Books {
	let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Book")
	let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
	try! context.execute(deleteRequest)
	
    var req = Book.request()
    req.includesPropertyValues = withProperties
    return try! context.fetch(req) ?? []
}

func GenerateBooks() {
    var books = getBooks(withProperties: false)
	var url = URL(string: "")
	
    if (books.count < 1) {
		#if DEBUG
		url = URL.init(fileURLWithPath: "/Users/luke/clippings.txt")
		#else
		var dialog = NSOpenPanel()

		dialog.canChooseDirectories = false
		dialog.showsHiddenFiles = false
		dialog.allowedFileTypes = ["txt"]
		if dialog.runModal() == NSApplication.ModalResponse.OK {
			url = dialog.url!
		}
		#endif
		var textContents: String = try! String(contentsOf: url!)
		books = getBooks(withProperties: true)
		ParseTextClippings(from: textContents, books)
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
	var parts = input.regexpReplace(#"(\n|\r|\t|\|)"#, with: "\n")
						.components(separatedBy: "\n")
						.filter({ $0 != "" })
						.map({ $0.trimmingCharacters(in: .whitespaces) })
	
	var title  = parts[0].regexpRemove(#"\(.+$"#)
	var author = parts[0].regexpRemove(#"(^.+\(|\))"#)
	var body   = parts.last!.removeFootnotes()
	
	return (title, author, body)
}

func ParseTextClippings(from text: String, _ alreadyGenerated: Books) {
    var books = alreadyGenerated
    var clippings = text.components(separatedBy: "==========")
    clippings.popLast()
	
	for var clip in clippings {
		var (title, author, body) = ParseClipping(clipping: clip)
		var alreadyGenerated = false
	
		for var (i, generatedBook) in books.enumerated() {
			if generatedBook.title == title {
				books[i].clippings!.append(body)
				alreadyGenerated = true
				break
			}
		}
	
		if !alreadyGenerated {
			var book = GetiTunesBook(title)
			var newBook = Book(context: context)
			newBook.title = title
			newBook.author = book.artistName
			newBook.clippings = [body]
			newBook.id = UUID()
			newBook.authorURL = book.artistViewUrl
			newBook.coverURL = book.artworkUrl100.regexpReplace("100x100bb", with: "0x200h")
			books.append(newBook)
		}
	}
}

func GetiTunesBook(_ title: String) -> iTunesBook {
	var URLSafeTitle = title.components(separatedBy: ":").first!
							.components(separatedBy: " ")
							.map({ $0.regexpRemove(#"[^\w]"#) })
							.joined(separator: "+")
	
	var searchURL = URL(string: "https://itunes.apple.com/search?term=\(URLSafeTitle)&entity=ebook")!
	let request = URLRequest(url: searchURL)
	
	let (data, _, _) = URLSession.shared.synchronousTask(request)
	var searchResults = try! JSONDecoder().decode(SearchResults.self, from: data!)
	
	return searchResults.results[0]
}
