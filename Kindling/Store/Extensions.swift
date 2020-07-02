//
//  Extensions.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-12.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Cocoa

typealias Clipping = String
typealias Clippings = [Clipping]

public enum QuoteType {
	case plain, citation
}

extension NSManagedObjectContext {
	func delete(book: Book) {
		let req = NSFetchRequest<Book>(entityName: "Book")
		req.predicate = NSPredicate(format: "id = %@", book.id! as CVarArg)
		let books = try! context.fetch(req)
		context.delete(books.first!)
	}
}

extension Clippings {
	func containsQuery(_ query: String) -> Bool {
		for clipping in self {
			if clipping.containsQuery(query) {
				return true
			}
		}
		return false
	}

	func filteredBy(_ query: String) -> Clippings {
		if query.count < 1 {
			return self
		}
		return self.filter { $0.containsQuery(query) }
	}
}

extension Clipping {
	func containsQuery(_ query: String) -> Bool {
		guard query.count > 0 else { return true }
		return self.range(of: "(^|[^A-Za-z])\(query)($|[^A-Za-z])", options: [.caseInsensitive, .regularExpression]) != nil
	}

	func withLeadingCapital() -> String {
		var str = self
		return str.remove(at: str.startIndex).uppercased() + str
	}

	func removeFootnotes() -> String {
		var str = self as NSString
		let regex = try! NSRegularExpression(pattern: #"([A-Za-z.,"'‘’“”;()!])([0-9]+)"#)
		let results = regex.matches(in: self, range: NSMakeRange(0, self.utf16.count))
		for result in results {
			let match = result.range(at: 2)
			str = str.replacingCharacters(in: match, with: "") as NSString
		}
		return str as String
	}

	func `as`(_ type: QuoteType, from book: Book? = nil) -> String {
		let clipping = self.withLeadingCapital()
		switch type {
			case .citation:
				return "\u{201c}\(clipping)\u{201d} \(book?.author ?? "No Author"), \(book?.title ?? "No Title")"
			case .plain:
				return clipping
		}
	}
}

extension String {
	func regexpRemove(_ regexp: String) -> String {
		return self.replacingOccurrences(of: regexp, with: "", options: .regularExpression)
	}

	func regexpReplace(_ regexp: String, with: String) -> String {
		return self.replacingOccurrences(of: regexp, with: with, options: .regularExpression)
	}
}

extension URLSession {
	func synchronousTask(_ request: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {
		var data: Data?
		var response: URLResponse?
		var error: Error?

		let semaphore = DispatchSemaphore(value: 0)

		let dataTask = self.dataTask(with: request) {
			data = $0
			response = $1
			error = $2

			semaphore.signal()
		}
		dataTask.resume()

		_ = semaphore.wait(timeout: .distantFuture)

		return (data, response, error)
	}
}
