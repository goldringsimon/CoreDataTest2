//
//  SongModel.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

struct SongModel: Hashable {
    var id: UUID?
    var title: String
    var composer: String
    
    init(title: String, composer: String) {
        self.title = title
        self.composer = composer
    }
}

extension SongModel {
    init(from song: ManagedSong) {
        id = song.id
        title = song.title ?? ""
        composer = song.composer ?? ""
    }
}
