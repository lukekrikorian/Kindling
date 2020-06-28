//
//  Book.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

typealias Clipping = String
typealias Books = [Book]
typealias Clippings = [Clipping]

extension Books {
	func filtered(by query: String) -> Books {
		if query.count < 1 {
			return self
		}
		return self.filter { $0.clippings!.contains(query) }
	}
}

public enum QuoteType {
	case normal, citation
}

extension Book {
	@nonobjc public class func request() -> NSFetchRequest<Book> {
		var req = NSFetchRequest<Book>(entityName: "Book")
		req.sortDescriptors = [
			NSSortDescriptor(keyPath: \Book.author, ascending: false),
			NSSortDescriptor(keyPath: \Book.title, ascending: false)
		]
		return req
	}

	@nonobjc public class func requestOnly(_ values: [String]) -> NSFetchRequest<Book> {
		var req = self.request()
		req.sortDescriptors = []
		req.includesPropertyValues = false
		return req
	}

	@nonobjc public func delete() {
		do {
			let req = NSFetchRequest<Book>(entityName: "Book")
			req.predicate = NSPredicate(format: "id = %@", self.id! as CVarArg)
			let books = try context.fetch(req)
			context.delete(books.first!)
		} catch {
			return
		}
	}
	
	@nonobjc public func selectedClippingCitation(_ type: QuoteType) -> String {
		switch type {
			case .citation:
				return "\u{201c}\(store.selectedClipping!)\u{201d} \(self.author!), \(self.title!)"
			case .normal:
				return store.selectedClipping!
		}
	}
}

extension Clippings {
	func index(of clipping: Clipping) -> Int {
		return self.index(of: clipping) ?? -1
	}

	func contains(_ query: String) -> Bool {
		return self.contains(where: { clipping in
			clipping.contains(query)
        })
	}

	func filtered(by query: String) -> Clippings {
		if query.count < 1 {
			return self
		}
		return self.filter { $0.contains(query) }
	}
}

extension Clipping {
	func contains(_ query: String) -> Bool {
		return self.range(of: "(^|[^A-Za-z])\(query)($|[^A-Za-z])", options: [.caseInsensitive, .regularExpression]) != nil
	}
}
