//
//  CoreDataRepStore.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/30/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataRepStore: NSObject, NSFetchedResultsControllerDelegate, RepStore {
    @Published private var folders: [FolderModel] = []
    var foldersPublisher: Published<[FolderModel]>.Publisher { $folders }
    
    private var repFolders: ManagedRepFolders?
    var modelController: ModelController!
    
    lazy private var fetchedResultsController: NSFetchedResultsController<ManagedRepFolders> = {
        let fetchRequest: NSFetchRequest<ManagedRepFolders> = ManagedRepFolders.fetchRequest()
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.sortDescriptors = []
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: modelController.persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
    }()
    
    private var context: NSManagedObjectContext!
    
    override init() {
        super.init()
        modelController = ModelController()
        context = modelController.persistentContainer.viewContext
        fetchedResultsController.delegate = self
        addMockData()
        //updateFetchRequest()
    }
    
    private func addMockData() {
        let song1 = SongModel(title: "She Cries", composer: "Jason Robert Brown")
        let song2 = SongModel(title: "Send In The Clowns", composer: "Stephen Sondheim")
        let song3 = SongModel(title: "I've Found A New Baby", composer: "Charlie Christian")
        
        let repBook = createFolder(fromModel: FolderModel(name: "Rep Book", color: nil, songs: [song1]))
        let inProgress = createFolder(fromModel: FolderModel(name: "In Progress", color: nil, songs: [song2, song3]))
        let stillToLearn = createFolder(fromModel: FolderModel(name: "Still To Learn", color: nil, songs: []))
        
        let repFolders = ManagedRepFolders.init(context: modelController.persistentContainer.viewContext)
        repFolders.addToFolders(repBook)
        repFolders.addToFolders(inProgress)
        repFolders.addToFolders(stillToLearn)
        print("rep books folder id is \(repBook.id)")
    }
    
    @discardableResult
    private func createSong(fromModel model: SongModel) -> ManagedSong {
        let song = ManagedSong(context: context)
        song.id = UUID()
        apply(model: model, to: song)
        return song
    }
    
    private func apply(model: SongModel, to song: ManagedSong) {
        song.title = model.title
        song.composer = model.composer
    }
    
    @discardableResult
    private func createFolder(fromModel model: FolderModel) -> ManagedFolder {
        let folder = ManagedFolder(context: context)
        folder.id = UUID()
        apply(model: model, to: folder)
        print(folder.name ?? "empty name")
        print(folder.id ?? "nil")
        return folder
    }
    
    private func apply(model: FolderModel, to folder: ManagedFolder) {
        folder.name = model.name
        folder.color = model.color
        folder.songs = NSOrderedSet(array: model.songs.map({ createSong(fromModel:$0) }))
    }
    
    func updateOrCreateSong(fromModel model: SongModel) {
      if model.id == nil {
        createSong(fromModel: model)
      } else {
        //updateSong(fromModel: model)
      }
      //try? persistentContainer.viewContext.save()
      //updateSongs()
    }
    
    func addFolder(folder: FolderModel) {
        repFolders?.addToFolders(createFolder(fromModel: folder))
    }
    
    func addSong(add song: SongModel, to folder: FolderModel) {
        
    }
    
    func addSongRandomly(song: SongModel) {
        if let managedFolders = repFolders?.folders?.array as? [ManagedFolder] {
            let newSong = createSong(fromModel: song)
            managedFolders.randomElement()?.addToSongs(newSong)
        }
        updateFetchRequest()
    }
    
    func deleteSong(song: SongModel, from folder: FolderModel?) -> Bool {
        defer {
            updateFetchRequest()
        }
        if let folder = folder {
            guard let foldersArray = repFolders?.folders?.array as? [ManagedFolder] else { return false }
            for currentFolder in foldersArray {
                if currentFolder.id == folder.id {
                    guard let songsArray = currentFolder.songs?.array as? [ManagedSong] else { return false }
                    for currentSong in songsArray {
                        if currentSong.id == song.id {
                            currentFolder.removeFromSongs(currentSong)
                            return true
                        }
                    }
                }
            }
        } else {
            guard let foldersArray = repFolders?.folders?.array as? [ManagedFolder] else { return false }
            for currentFolder in foldersArray {
                guard let songsArray = currentFolder.songs?.array as? [ManagedSong] else { return false }
                for currentSong in songsArray {
                    if currentSong.id == song.id {
                        currentFolder.removeFromSongs(currentSong)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func updateFetchRequest() {
        try? fetchedResultsController.performFetch()
    }
    
    /*func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        guard let repFoldersID = snapshot.itemIdentifiers.first else { return }
        if let repFolders = try? modelController.persistentContainer.viewContext.existingObject(with: repFoldersID) as? RepFolders {
            guard let foldersArray = repFolders.folders?.array as? [Folder] else { return }
            
            var newSnapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
            
            for folder in foldersArray {
                newSnapshot.appendSections([folder.name ?? "unnamed folder"])
                if let songs = folder.songs?.array as? [Song] {
                    //newSnapshot.appendItems(songs.map({ $0.title ?? "unnamed song" }))
                    newSnapshot.appendItems(songs.map({ SongModel.init(from: $0) }))
                }
            }
            //dataSource.apply(newSnapshot)
        }
    }*/
    
    /*func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedRepFolders = controller.fetchedObjects?.first as? ManagedRepFolders {
            repFolders = fetchedRepFolders
            guard let foldersArray = repFolders?.folders?.array as? [ManagedFolder] else { return }
            folders = foldersArray.map(FolderModel.init)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let fetchedRepFolders = controller.fetchedObjects?.first as? ManagedRepFolders {
            repFolders = fetchedRepFolders
            guard let foldersArray = repFolders?.folders?.array as? [ManagedFolder] else { return }
            folders = foldersArray.map(FolderModel.init)
        }
    }*/
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
        guard let repFoldersID = snapshot.itemIdentifiers.first else { return }
        if let repFolders = try? modelController.persistentContainer.viewContext.existingObject(with: repFoldersID) as? ManagedRepFolders {
            self.repFolders = repFolders
            guard let foldersArray = repFolders.folders?.array as? [ManagedFolder] else { return }
            folders = foldersArray.map(FolderModel.init)
        }
    }
    
    /*func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let repFolders = anObject as? ManagedRepFolders {
            if let foldersArray = repFolders.folders?.array as? [ManagedFolder] {
                folders = foldersArray.map({ FolderModel(from: $0) })
            }
        }
    }*/
}
