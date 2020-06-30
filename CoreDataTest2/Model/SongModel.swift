//
//  SongModel.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

struct SongModel: Hashable {
    private var song: Song? = nil
    var title: String
    var composer: String
    
    init(title: String, composer: String) {
        self.title = title
        self.composer = composer
    }
}

extension SongModel {
    init(from song: Song) {
        self.song = song
        self.title = song.title ?? ""
        self.composer = song.composer ?? ""
    }
}
