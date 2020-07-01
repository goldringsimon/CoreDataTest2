//
//  ManagedImage+CoreDataProperties.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 7/1/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedImage> {
        return NSFetchRequest<ManagedImage>(entityName: "ManagedImage")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: Data?
    @NSManaged public var song: ManagedSong?

}
