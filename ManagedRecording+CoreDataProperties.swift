//
//  ManagedRecording+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 7/1/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedRecording {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedRecording> {
        return NSFetchRequest<ManagedRecording>(entityName: "ManagedRecording")
    }

    @NSManaged public var name: String?
    @NSManaged public var recording: Data?
    @NSManaged public var song: ManagedSong?

}
