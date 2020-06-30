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
    
    private var repFolders: ManagedRepFolders!
    var modelController: ModelController!
    
    typealias SectionType = String
    typealias ItemType = SongModel
    
    lazy var fetchedResultsController: NSFetchedResultsController<ManagedRepFolders> = {
        let fetchRequest: NSFetchRequest<ManagedRepFolders> = ManagedRepFolders.fetchRequest()
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.sortDescriptors = []
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: modelController.persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        //controller.delegate = self.fetchedResultsController
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
    }()
    
    override init() {
        super.init()
        modelController = ModelController()
    }
    
    func addFolder(folder: FolderModel) {
        
    }
    
    func addSong(add song: SongModel, to folder: FolderModel) {
        
    }
    
    func addSongRandomly(song: SongModel) {
        
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
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let repFolders = anObject as? ManagedRepFolders {
            if let foldersArray = repFolders.folders?.array as? [ManagedFolder] {
                folders = foldersArray.map({ FolderModel(from: $0) })
            }
        }
    }
}
