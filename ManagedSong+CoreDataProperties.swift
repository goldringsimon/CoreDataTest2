//
//  ManagedSong+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
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

}
