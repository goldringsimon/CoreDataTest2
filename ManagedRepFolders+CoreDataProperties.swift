//
//  ManagedRepFolders+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedRepFolders {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedRepFolders> {
        return NSFetchRequest<ManagedRepFolders>(entityName: "ManagedRepFolders")
    }

    @NSManaged public var folders: NSOrderedSet?

}

// MARK: Generated accessors for folders
extension ManagedRepFolders {

    @objc(insertObject:inFoldersAtIndex:)
    @NSManaged public func insertIntoFolders(_ value: ManagedFolder, at idx: Int)

    @objc(removeObjectFromFoldersAtIndex:)
    @NSManaged public func removeFromFolders(at idx: Int)

    @objc(insertFolders:atIndexes:)
    @NSManaged public func insertIntoFolders(_ values: [ManagedFolder], at indexes: NSIndexSet)

    @objc(removeFoldersAtIndexes:)
    @NSManaged public func removeFromFolders(at indexes: NSIndexSet)

    @objc(replaceObjectInFoldersAtIndex:withObject:)
    @NSManaged public func replaceFolders(at idx: Int, with value: ManagedFolder)

    @objc(replaceFoldersAtIndexes:withFolders:)
    @NSManaged public func replaceFolders(at indexes: NSIndexSet, with values: [ManagedFolder])

    @objc(addFoldersObject:)
    @NSManaged public func addToFolders(_ value: ManagedFolder)

    @objc(removeFoldersObject:)
    @NSManaged public func removeFromFolders(_ value: ManagedFolder)

    @objc(addFolders:)
    @NSManaged public func addToFolders(_ values: NSOrderedSet)

    @objc(removeFolders:)
    @NSManaged public func removeFromFolders(_ values: NSOrderedSet)

}
