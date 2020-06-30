//
//  ManagedFolder+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedFolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedFolder> {
        return NSFetchRequest<ManagedFolder>(entityName: "ManagedFolder")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var repFolder: ManagedRepFolders?
    @NSManaged public var songs: NSOrderedSet?

}

// MARK: Generated accessors for songs
extension ManagedFolder {

    @objc(insertObject:inSongsAtIndex:)
    @NSManaged public func insertIntoSongs(_ value: ManagedSong, at idx: Int)

    @objc(removeObjectFromSongsAtIndex:)
    @NSManaged public func removeFromSongs(at idx: Int)

    @objc(insertSongs:atIndexes:)
    @NSManaged public func insertIntoSongs(_ values: [ManagedSong], at indexes: NSIndexSet)

    @objc(removeSongsAtIndexes:)
    @NSManaged public func removeFromSongs(at indexes: NSIndexSet)

    @objc(replaceObjectInSongsAtIndex:withObject:)
    @NSManaged public func replaceSongs(at idx: Int, with value: ManagedSong)

    @objc(replaceSongsAtIndexes:withSongs:)
    @NSManaged public func replaceSongs(at indexes: NSIndexSet, with values: [ManagedSong])

    @objc(addSongsObject:)
    @NSManaged public func addToSongs(_ value: ManagedSong)

    @objc(removeSongsObject:)
    @NSManaged public func removeFromSongs(_ value: ManagedSong)

    @objc(addSongs:)
    @NSManaged public func addToSongs(_ values: NSOrderedSet)

    @objc(removeSongs:)
    @NSManaged public func removeFromSongs(_ values: NSOrderedSet)

}
