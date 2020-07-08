//
//  Database.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-03.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa

let context = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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

func getBooksCount() -> Int {
	let req: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()

	#if FORCE_RELOAD_BOOK_DATA
	print("Force reloading book data")
	let deleteRequest = NSBatchDeleteRequest(fetchRequest: req)
	try! context.execute(deleteRequest)
	#endif

	req.includesPropertyValues = false
	let count = (try! context.fetch(req)).count
	return count
}

func AddNewClipping(_ title: String, _ author: String, _ clipping: String) {
	let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
	let author = author.trimmingCharacters(in: .whitespacesAndNewlines)
	let clipping = clipping.trimmingCharacters(in: .whitespacesAndNewlines)

	let req: NSFetchRequest<Book> = Book.fetchRequest()
	req.predicate = NSPredicate(format: "title ==[cd] %@", title)

	do {
		let results = try context.fetch(req)
		if results.count > 0 {
//			print("Found book already created..")
			results[0].clippings!.append(clipping)
			return
		}
	} catch {
		print(error)
	}

	let book: Book = Book(context: context)

	let shortTitle = title.searchSanitized()

	book.id = UUID()
	book.title = title.count > 0 ? title : "Unknown Title"
	book.author = author.count > 0 ? author : "Unknown Author"
	book.clippings = [clipping]

	if title.count > 0 {
		print("Getting iTunes Data for \(shortTitle)")
		if let data = GetiTunesBook(from: shortTitle), data.trackName.searchSanitized().localizedCaseInsensitiveContains(shortTitle) {
//			book.title = data.trackName
			book.author = data.artistName
			book.authorURL = data.artistViewUrl
			book.coverURL = data.artworkUrl100.regexpReplace("100x100bb", with: "0x200h")
		}
	}
}

func GetiTunesBook(from title: String) -> iTunesBook? {
	let safeTitle = title.components(separatedBy: " ")
		.joined(separator: "+")

	let searchURL = URL(string: "https://itunes.apple.com/search?term=\(safeTitle)&entity=ebook")!
	let request = URLRequest(url: searchURL)

	let (data, _, error) = URLSession.shared.synchronousTask(request)

	guard error == nil, data != nil else { return nil }

	do {
		let results = try JSONDecoder().decode(SearchResults.self, from: data!).results
		guard results.count > 0 else { return nil }
		return results[0]
	} catch { return nil }
}
