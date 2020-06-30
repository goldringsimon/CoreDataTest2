//
//  MockRepStore.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation

class MockRepStore: RepStore {
    @Published private var folders: [FolderModel] = []
    var foldersPublisher: Published<[FolderModel]>.Publisher { $folders }
    
    init() {
        addMockData()
    }
    
    func addFolder(folder: FolderModel) {
        folders.append(folder)
    }
    
    func addSong(add song: SongModel, to folder: FolderModel) {        
        for (i, currentFolder) in folders.enumerated() {
            if (currentFolder == folder) {
                var newFolder = folder
                newFolder.songs.append(song)
                folders[i] = newFolder
                break
            }
        }
    }
    
    func addSongRandomly(song: SongModel) {
        folders[Int.random(in: 0..<folders.count)].songs.append(song)
    }
    
    @discardableResult
    func deleteSong(song: SongModel, from folder: FolderModel? = nil) -> Bool {
        if let folder = folder {
            for (i, currentFolder) in folders.enumerated() {
                if currentFolder == folder {
                    for (j, currentSong) in currentFolder.songs.enumerated() {
                        if currentSong == song {
                            folders[i].songs.remove(at: j)
                            return true
                        }
                    }
                }
            }
        } else {
            for (i, folder) in folders.enumerated() {
                for (j, currentSong) in folder.songs.enumerated() {
                    if currentSong == song {
                        folders[i].songs.remove(at: j)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func addMockData() {
        let song1 = SongModel(title: "She Cries", composer: "Jason Robert Brown")
        let song2 = SongModel(title: "Send In The Clowns", composer: "Stephen Sondheim")
        let song3 = SongModel(title: "I've Found A New Baby", composer: "Charlie Christian")
        
        let repBook = FolderModel(name: "Rep Book", color: nil, songs: [song1])
        let inProgress = FolderModel(name: "In Progress", color: nil, songs: [song2, song3])
        let stillToLearn = FolderModel(name: "Still To Learn", color: nil, songs: [])
        
        folders.append(contentsOf: [repBook, inProgress, stillToLearn])
        
        addSong(add: SongModel(title: "test added song", composer: "simon"), to: stillToLearn)
    }
}
