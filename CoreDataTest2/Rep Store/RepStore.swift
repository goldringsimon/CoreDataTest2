//
//  Store.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

protocol ReadableRepStore {
    var foldersPublisher: Published<[FolderModel]>.Publisher { get }
}

protocol WriteableRepStore {
    func addFolder(folder: FolderModel)
    func addSong(add song: SongModel, to folder: FolderModel)
    func addSongRandomly(song: SongModel)
}

typealias RepStore = ReadableRepStore & WriteableRepStore
