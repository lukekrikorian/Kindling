//
//  Extensions.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-12.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import CoreData
import SwiftUI

typealias Clippings = Set<Clipping>

public enum QuoteType {
	case plain, citation
}

//extension NSManagedObjectContext {
//	func delete(book: Book) {
//		let req = NSFetchRequest<Book>(entityName: "Book")
//		req.predicate = NSPredicate(format: "id = %@", book.id! as CVarArg)
//		let books = try! self.fetch(req)
//		self.delete(books.first!)
//	}
//}

extension Book {
	func containsQuery(_ query: String) -> Bool {
		for clipping in self.clippings {
			if clipping.contains(query) {
				return true
			}
		}
		return false
	}

	func filteredClippings(by query: String) -> Clippings {
		if query.count < 1 {
			return self.clippings
		}
		return self.clippings.filter { $0.contains(query) }
	}
}

extension Clipping {
	func contains(_ query: String) -> Bool {
		guard query.count > 0 else { return true }
		return self.text.range(of: "(^|[^A-Za-z])\(query)($|[^A-Za-z])", options: [.caseInsensitive, .regularExpression]) != nil
	}

	func withLeadingCapital() -> String {
		guard self.text.count > 0 else { return self.text }
		var str = self.text
		return str.remove(at: str.startIndex).uppercased() + str
	}

	func `as`(_ type: QuoteType) -> String {
		let clipping = self.withLeadingCapital()
		switch type {
			case .citation:
				return "\u{201c}\(clipping)\u{201d} \(self.book.author), \(self.book.title)"
			case .plain:
				return clipping
		}
	}
}

extension Clippings {
	func contains(_ query: String) -> Bool {
		for clipping in self {
			if clipping.contains(query) { return true }
		}
		return false
	}
}

extension String {
	func regexpRemove(_ regexp: String) -> String {
		return self.replacingOccurrences(of: regexp, with: "", options: .regularExpression)
	}

	func regexpReplace(_ regexp: String, with: String) -> String {
		return self.replacingOccurrences(of: regexp, with: with, options: .regularExpression)
	}

	func shortened() -> String {
		return self.components(separatedBy: ":")[0]
			.trimmingCharacters(in: .whitespacesAndNewlines)
	}

	func sanitized() -> String {
		return self.lowercased()
			.shortened()
			.regexpRemove(#"[^ \w]"#)
	}
	
	func removeFootnotes() -> String {
		let str: NSMutableString = NSMutableString(string: self)
		let regex = try! NSRegularExpression(pattern: #"([A-Za-z.,"'‘’“”;:()!])([0-9]+)"#)
		regex.replaceMatches(in: str, range: NSMakeRange(0, self.utf16.count), withTemplate: "")
		return str as String
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

enum OperatingSystem {
	case macOS
	case iOS
	case tvOS
	case watchOS

	#if os(macOS)
	static let current = macOS
	#elseif os(iOS)
	static let current = iOS
	#elseif os(tvOS)
	static let current = tvOS
	#elseif os(watchOS)
	static let current = watchOS
	#else
	#error("Unsupported platform")
	#endif
}

extension View {
	/**
	 Conditionally apply modifiers depending on the target operating system.

	 ```
	 struct ContentView: View {
	     var body: some View {
	         Text("Unicorn")
	             .font(.system(size: 10))
	             .ifOS(.macOS, .tvOS) {
	                 $0.font(.system(size: 20))
	             }
	     }
	 }
	 ```
	 */
	@ViewBuilder
	func ifOS<Content: View>(
		_ operatingSystems: OperatingSystem...,
		modifier: @escaping (Self) -> Content
	) -> some View {
		if operatingSystems.contains(OperatingSystem.current) {
			modifier(self)
		} else {
			self
		}
	}

	/**
	 ```
	 struct ContentView: View {
	 var body: some View {
	 Text("Unicorn")
	 .modify {
	 #if os(iOS)
	 return $0.actionSheet(…).eraseToAnyView()
	 #endif

	 return nil
	 }
	 }
	 }
	 ```
	 **/
	@ViewBuilder
	func modify(_ modifier: (Self) -> AnyView?) -> some View {
		if let view = modifier(self) {
			view
		} else {
			self
		}
	}

	func asAny() -> AnyView {
		AnyView(self)
	}
}
