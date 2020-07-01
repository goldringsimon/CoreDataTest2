//
//  ManagedDocument+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 7/1/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedDocument {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedDocument> {
        return NSFetchRequest<ManagedDocument>(entityName: "ManagedDocument")
    }

    @NSManaged public var name: String?
    @NSManaged public var document: Data?
    @NSManaged public var song: ManagedSong?

}
