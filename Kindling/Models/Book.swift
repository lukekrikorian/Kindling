//
//  Book.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-03-19.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//

import SwiftUI

typealias Clipping = String
typealias Books = Array<Book>
typealias Clippings = Array<Clipping>

extension Books {
    func filtered(by query: String) -> Books {
        if (query.count < 1) {
            return self
        }
        return self.filter { $0.clippings!.contains(query) }
    }
}

extension Book {
    @nonobjc public class func request() -> NSFetchRequest<Book> {
        var req = NSFetchRequest<Book>(entityName: "Book");
        req.sortDescriptors = []
        return req
    }
    @nonobjc public class func requestOnly(_ values: [String]) -> NSFetchRequest<Book> {
        var req = self.request()
        req.sortDescriptors = []
        req.includesPropertyValues = false
        return req
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
        if (query.count < 1) {
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



