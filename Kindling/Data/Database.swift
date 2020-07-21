//
//  Database.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-03.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData

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

func getBooksCount(from context: NSManagedObjectContext) -> Int {
	let req: NSFetchRequest<NSFetchRequestResult> = Book.fetchRequest()

	#if FORCE_RELOAD_BOOK_DATA
	print("Force reloading book data")
	let deleteRequest = NSBatchDeleteRequest(fetchRequest: req)
	do { try context.execute(deleteRequest) } catch { print(error) }
	#endif

	req.includesPropertyValues = false
	let count = (try! context.fetch(req)).count
	print("Found \(count) books")
	return count
}

func AddNewClipping(to context: NSManagedObjectContext, _ title: String, _ author: String, _ body: String, _ page: Int16 = 0, _ date: Date = Date()) {
	let title = title.trimmingCharacters(in: .whitespacesAndNewlines)
	let author = author.trimmingCharacters(in: .whitespacesAndNewlines)
	let body = body.trimmingCharacters(in: .whitespacesAndNewlines)

	let req: NSFetchRequest<Book> = Book.fetchRequest()
	req.predicate = NSPredicate(format: "title ==[cd] %@", title)
	
	let clipping = Clipping(context: context)
	clipping.text = body
	clipping.page = Int16(page)
	clipping.date = date
	clipping.id = UUID()

	do {
		let results = try context.fetch(req)
		if results.count > 0 {
			results[0].addToClippings(clipping)
			return
		}
	} catch {
		print(error)
	}

	let book: Book = Book(context: context)
	
	let shortTitle = title.sanitized()

	book.id = UUID()
	book.title = title.count > 0 ? title : "Unknown Title"
	book.author = author.count > 0 ? author : "Unknown Author"
	book.clippings = [clipping]

	if title.count > 0 {
		print("Getting iTunes Data for \(shortTitle)")
		GetiTunesBook(from: shortTitle) { data in
			if let data = data,
				data.trackName.sanitized().localizedCaseInsensitiveContains(shortTitle) {
				book.author = data.artistName
				book.authorURL = data.artistViewUrl
				book.coverURL = data.artworkUrl100.regexpReplace("100x100bb", with: "0x200h")
			}
		}
	}
}

func GetiTunesBook(from title: String, then: @escaping (_ book: iTunesBook?) -> ()) {
	let safeTitle = title.components(separatedBy: " ")
		.joined(separator: "+")

	let searchURL = URL(string: "https://itunes.apple.com/search?term=\(safeTitle)&entity=ebook")!
	let request = URLRequest(url: searchURL)

	let task = URLSession.shared.dataTask(with: request) { data, _, error in
		guard error == nil, data != nil else {
			print(error ?? "")
			return
		}
		do {
			let results = try JSONDecoder().decode(SearchResults.self, from: data!).results
			guard results.count > 0 else { return }
			then(results[0])
		} catch { return }
	}
	task.resume()
}
