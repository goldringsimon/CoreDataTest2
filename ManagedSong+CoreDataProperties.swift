//
//  ManagedSong+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 7/1/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedSong {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedSong> {
        return NSFetchRequest<ManagedSong>(entityName: "ManagedSong")
    }

    @NSManaged public var composer: String?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var folder: ManagedFolder?
    @NSManaged public var images: NSOrderedSet?
    @NSManaged public var recordings: NSOrderedSet?
    @NSManaged public var documents: NSOrderedSet?

}

// MARK: Generated accessors for images
extension ManagedSong {

    @objc(insertObject:inImagesAtIndex:)
    @NSManaged public func insertIntoImages(_ value: ManagedImage, at idx: Int)

    @objc(removeObjectFromImagesAtIndex:)
    @NSManaged public func removeFromImages(at idx: Int)

    @objc(insertImages:atIndexes:)
    @NSManaged public func insertIntoImages(_ values: [ManagedImage], at indexes: NSIndexSet)

    @objc(removeImagesAtIndexes:)
    @NSManaged public func removeFromImages(at indexes: NSIndexSet)

    @objc(replaceObjectInImagesAtIndex:withObject:)
    @NSManaged public func replaceImages(at idx: Int, with value: ManagedImage)

    @objc(replaceImagesAtIndexes:withImages:)
    @NSManaged public func replaceImages(at indexes: NSIndexSet, with values: [ManagedImage])

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ManagedImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ManagedImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSOrderedSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSOrderedSet)

}

// MARK: Generated accessors for recordings
extension ManagedSong {

    @objc(insertObject:inRecordingsAtIndex:)
    @NSManaged public func insertIntoRecordings(_ value: ManagedRecording, at idx: Int)

    @objc(removeObjectFromRecordingsAtIndex:)
    @NSManaged public func removeFromRecordings(at idx: Int)

    @objc(insertRecordings:atIndexes:)
    @NSManaged public func insertIntoRecordings(_ values: [ManagedRecording], at indexes: NSIndexSet)

    @objc(removeRecordingsAtIndexes:)
    @NSManaged public func removeFromRecordings(at indexes: NSIndexSet)

    @objc(replaceObjectInRecordingsAtIndex:withObject:)
    @NSManaged public func replaceRecordings(at idx: Int, with value: ManagedRecording)

    @objc(replaceRecordingsAtIndexes:withRecordings:)
    @NSManaged public func replaceRecordings(at indexes: NSIndexSet, with values: [ManagedRecording])

    @objc(addRecordingsObject:)
    @NSManaged public func addToRecordings(_ value: ManagedRecording)

    @objc(removeRecordingsObject:)
    @NSManaged public func removeFromRecordings(_ value: ManagedRecording)

    @objc(addRecordings:)
    @NSManaged public func addToRecordings(_ values: NSOrderedSet)

    @objc(removeRecordings:)
    @NSManaged public func removeFromRecordings(_ values: NSOrderedSet)

}

// MARK: Generated accessors for documents
extension ManagedSong {

    @objc(insertObject:inDocumentsAtIndex:)
    @NSManaged public func insertIntoDocuments(_ value: ManagedDocument, at idx: Int)

    @objc(removeObjectFromDocumentsAtIndex:)
    @NSManaged public func removeFromDocuments(at idx: Int)

    @objc(insertDocuments:atIndexes:)
    @NSManaged public func insertIntoDocuments(_ values: [ManagedDocument], at indexes: NSIndexSet)

    @objc(removeDocumentsAtIndexes:)
    @NSManaged public func removeFromDocuments(at indexes: NSIndexSet)

    @objc(replaceObjectInDocumentsAtIndex:withObject:)
    @NSManaged public func replaceDocuments(at idx: Int, with value: ManagedDocument)

    @objc(replaceDocumentsAtIndexes:withDocuments:)
    @NSManaged public func replaceDocuments(at indexes: NSIndexSet, with values: [ManagedDocument])

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: ManagedDocument)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: ManagedDocument)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSOrderedSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSOrderedSet)

}
