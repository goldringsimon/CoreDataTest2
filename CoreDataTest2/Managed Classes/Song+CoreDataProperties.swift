//
//  Song+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/28/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var title: String?
    @NSManaged public var composer: String?
    @NSManaged public var folder: Folder?

}
