//
//  Book+CoreDataClass.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-12.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//
//

import CoreData
import Foundation

public class Book: NSManagedObject {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
		return NSFetchRequest<Book>(entityName: "Book")
	}

	@NSManaged public var id: UUID?
	@NSManaged public var title: String
	@NSManaged public var author: String
	@NSManaged public var clippings: Set<Clipping>
	@NSManaged public var authorURL: String?
	@NSManaged public var coverURL: String?
}

// MARK: Generated accessors for clippings

extension Book {
	@objc(insertObject:inClippingsAtIndex:)
	@NSManaged public func insertIntoClippings(_ value: Clipping, at idx: Int)

	@objc(removeObjectFromClippingsAtIndex:)
	@NSManaged public func removeFromClippings(at idx: Int)

	@objc(insertClippings:atIndexes:)
	@NSManaged public func insertIntoClippings(_ values: [Clipping], at indexes: NSIndexSet)

	@objc(removeClippingsAtIndexes:)
	@NSManaged public func removeFromClippings(at indexes: NSIndexSet)

	@objc(replaceObjectInClippingsAtIndex:withObject:)
	@NSManaged public func replaceClippings(at idx: Int, with value: Clipping)

	@objc(replaceClippingsAtIndexes:withClippings:)
	@NSManaged public func replaceClippings(at indexes: NSIndexSet, with values: [Clipping])

	@objc(addClippingsObject:)
	@NSManaged public func addToClippings(_ value: Clipping)

	@objc(removeClippingsObject:)
	@NSManaged public func removeFromClippings(_ value: Clipping)

	@objc(addClippings:)
	@NSManaged public func addToClippings(_ values: NSOrderedSet)

	@objc(removeClippings:)
	@NSManaged public func removeFromClippings(_ values: NSOrderedSet)
}
