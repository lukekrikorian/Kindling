//
//  Clipping+CoreDataProperties.swift
//  Kindling
//
//  Created by Luke Krikorian on 2020-07-12.
//  Copyright © 2020 Luke Krikorian. All rights reserved.
//
//

import Foundation
import CoreData

public class Clipping: NSManagedObject {
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Clipping> {
        return NSFetchRequest<Clipping>(entityName: "Clipping")
    }

	@NSManaged public var id: UUID?
    @NSManaged public var page: Int16
    @NSManaged public var text: String
    @NSManaged public var book: Book
	@NSManaged public var date: Date
}

extension Clipping: Comparable {
	public static func < (lhs: Clipping, rhs: Clipping) -> Bool {
		return lhs.page < rhs.page
	}
}
