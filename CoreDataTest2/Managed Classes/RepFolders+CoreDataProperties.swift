//
//  RepFolders+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/28/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension RepFolders {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepFolders> {
        return NSFetchRequest<RepFolders>(entityName: "RepFolders")
    }

    @NSManaged public var folders: NSOrderedSet?

}

// MARK: Generated accessors for folders
extension RepFolders {

    @objc(insertObject:inFoldersAtIndex:)
    @NSManaged public func insertIntoFolders(_ value: Folder, at idx: Int)

    @objc(removeObjectFromFoldersAtIndex:)
    @NSManaged public func removeFromFolders(at idx: Int)

    @objc(insertFolders:atIndexes:)
    @NSManaged public func insertIntoFolders(_ values: [Folder], at indexes: NSIndexSet)

    @objc(removeFoldersAtIndexes:)
    @NSManaged public func removeFromFolders(at indexes: NSIndexSet)

    @objc(replaceObjectInFoldersAtIndex:withObject:)
    @NSManaged public func replaceFolders(at idx: Int, with value: Folder)

    @objc(replaceFoldersAtIndexes:withFolders:)
    @NSManaged public func replaceFolders(at indexes: NSIndexSet, with values: [Folder])

    @objc(addFoldersObject:)
    @NSManaged public func addToFolders(_ value: Folder)

    @objc(removeFoldersObject:)
    @NSManaged public func removeFromFolders(_ value: Folder)

    @objc(addFolders:)
    @NSManaged public func addToFolders(_ values: NSOrderedSet)

    @objc(removeFolders:)
    @NSManaged public func removeFromFolders(_ values: NSOrderedSet)

}
