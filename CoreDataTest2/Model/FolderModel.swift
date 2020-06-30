//
//  FolderModel.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation
import UIKit

struct FolderModel: Hashable {
    public var name: String
    public var color: UIColor?
    public var songs: [SongModel]
}

extension FolderModel {
    init(from folder: Folder) {
        self.name = folder.name ?? ""
        self.color = folder.color as? UIColor
        if let songs = folder.songs?.array as? [Song] {
            self.songs = songs.map({ SongModel(from: $0) })
        } else {
            self.songs = []
        }
    }
}
