//
//  Extensions.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-05-12.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import Foundation

/* Helper array method, used to filter through clippings */

extension Array where Iterator.Element == String {
	func filterWithIndex(_ filter: (Int, String) -> Bool) -> [String] {
		var filteredArray: [String] = []
		for (index, value) in self.enumerated() {
			if filter(index, value) {
				filteredArray.append(value)
			}
		}
		return filteredArray
	}
}

extension String {
	func regexpRemove(_ regexp: String) -> String {
		return self.replacingOccurrences(of: regexp, with: "", options: .regularExpression)
	}

	func regexpReplace(_ regexp: String, with: String) -> String {
		return self.replacingOccurrences(of: regexp, with: with, options: .regularExpression)
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
			var match = result.range(at: 2)
			str = str.replacingCharacters(in: match, with: "") as NSString
		}
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
