//
//  ViewController.swift
//  CoreDataTest2
//
//  Created by Simon Goldring on 6/28/20.
//  Copyright © 2020 Simon Goldring. All rights reserved.
//

import UIKit
import CoreData
import Combine

class HomeViewController: UIViewController {
    let reuseIdentifier = "reuse-id"
    
    /*lazy var fetchedResultsController: NSFetchedResultsController<RepFolders> = {
        let fetchRequest: NSFetchRequest<RepFolders> = RepFolders.fetchRequest()
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
    }()*/
    
    typealias SectionType = String
    typealias ItemType = SongModel
    
    //var modelController: ModelController!
    
    var tableView: UITableView!
    var dataSource: DataSource!
    
    /*var repFolders: RepFolders!
    var repBook: Folder!
    var inProgress: Folder!
    var stillToLearn: Folder!*/
    
    var repStore: RepStore!
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureModelController()
        configureHierarchy()
        configureDataSource()
        configureNavigationItem()
        //fetchedResultsController.delegate = self
        //configureSampleData()
        
        repStore = MockRepStore()
        
        cancellable = repStore.foldersPublisher.sink(receiveValue: { [weak self] folderModels in
            var newSnapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
            
            for folder in folderModels {
                newSnapshot.appendSections([folder.name])
                newSnapshot.appendItems(folder.songs)
            }
            self?.dataSource.apply(newSnapshot)
        })
        
        //repStore.folders.append(FolderModel(name: "test folder", color: nil, songs: []))
        
    }

    /*func configureModelController() {
        modelController = ModelController()
    }*/
    
    /*func configureSampleData() {
        let song1 = Song.init(context: modelController.persistentContainer.viewContext)
        song1.title = "She Cries"
        song1.composer = "Jason Robert Brown"
        
        let song2 = Song.init(context: modelController.persistentContainer.viewContext)
        song2.title = "Send In The Clowns"
        song2.composer = "Stephen Sondheim"
        
        let song3 = Song.init(context: modelController.persistentContainer.viewContext)
        song3.title = "I've Found A New Baby"
        song3.composer = "Charlie Christian"
        
        repBook = Folder.init(context: modelController.persistentContainer.viewContext)
        repBook.name = "Rep Book"
        repBook.addToSongs(song1)
        
        inProgress = Folder.init(context: modelController.persistentContainer.viewContext)
        inProgress.name = "In Progress"
        inProgress.addToSongs(song2)
        inProgress.addToSongs(song3)
        
        stillToLearn = Folder.init(context: modelController.persistentContainer.viewContext)
        stillToLearn.name = "Still To Learn"
        
        repFolders = RepFolders.init(context: modelController.persistentContainer.viewContext)
        repFolders.addToFolders(repBook)
        repFolders.addToFolders(inProgress)
        repFolders.addToFolders(stillToLearn)
    }*/
}

extension HomeViewController {
    func configureHierarchy() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SongTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        //tableView.isEditing = true
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        tableView.delegate = self
    }
    
    class SongTableViewCell: UITableViewCell {
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
            self.accessoryType = .disclosureIndicator
        }
        
        required init?(coder: NSCoder) {
            fatalError("not implementing this")
        }
    }
    
    func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, songModel) -> UITableViewCell? in
            if let cell = tableView.dequeueReusableCell(withIdentifier: self!.reuseIdentifier, for: indexPath) as? SongTableViewCell {
                cell.textLabel?.text = songModel.title
                cell.detailTextLabel?.text = songModel.composer
                return cell
            }
            return nil
        })
    }
    
    func configureNavigationItem() {
        navigationItem.title = "Repertoire"
        /*let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
        navigationItem.rightBarButtonItem = addItem*/
    }
    /*
    @objc func addSong() {
        let ac = UIAlertController(title: "Add Song", message: "Title and Composer:", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Done", style: .default) { [weak self, weak ac] alertAction in
            guard let self = self else { return }
            let songTitle = ac?.textFields![0].text ?? ""
            let songComposer = ac?.textFields![1].text ?? ""
            let newSong = Song(context: self.modelController.persistentContainer.viewContext)
            newSong.title = songTitle
            newSong.composer = songComposer
            //self.inProgress.addToSongs(newSong)
            if let folders = self.repFolders.folders?.array as? [Folder] {
                folders.randomElement()?.addToSongs(newSong)
            }
            //self.repFolders.folders = self.repFolders.folders?.reversed
            
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print(error.localizedDescription)
            }
            
            /*do {
                try self.viewContext.save()
            } catch {
                print(error.localizedDescription)
            }*/
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }*/
}

extension HomeViewController {
    class DataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
        // MARK: header/footer titles support
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let snapshot = self.snapshot()
            
            //viewContext.existingObject(with: snapshot.sectionIdentifiers[section])
            return snapshot.sectionIdentifiers[section]
        }
        
        /*override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
            "Footer for a folder"
        }*/
        
        override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            guard let sourceIdentifier = itemIdentifier(for: sourceIndexPath) else { return }
            guard sourceIndexPath != destinationIndexPath else { return }
            let destinationIdentifier = itemIdentifier(for: destinationIndexPath)
            
            var snapshot = self.snapshot()

            if let destinationIdentifier = destinationIdentifier {
                if let sourceIndex = snapshot.indexOfItem(sourceIdentifier),
                   let destinationIndex = snapshot.indexOfItem(destinationIdentifier) {
                    let isAfter = destinationIndex > sourceIndex &&
                        snapshot.sectionIdentifier(containingItem: sourceIdentifier) ==
                        snapshot.sectionIdentifier(containingItem: destinationIdentifier)
                    snapshot.deleteItems([sourceIdentifier])
                    if isAfter {
                        snapshot.insertItems([sourceIdentifier], afterItem: destinationIdentifier)
                    } else {
                        snapshot.insertItems([sourceIdentifier], beforeItem: destinationIdentifier)
                    }
                }
            } else {
                let destinationSectionIdentifier = snapshot.sectionIdentifiers[destinationIndexPath.section]
                snapshot.deleteItems([sourceIdentifier])
                snapshot.appendItems([sourceIdentifier], toSection: destinationSectionIdentifier)
            }
            apply(snapshot, animatingDifferences: false)
        }
        
        // MARK: editing support

        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let identifierToDelete = itemIdentifier(for: indexPath) {
                    var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)
                }
            }
        }
    }
}

/*extension HomeViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
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
            dataSource.apply(newSnapshot)
        }
    }
}*/

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let newAction = UIContextualAction(style: .normal, title: "Action") { (action, sourceView, completion) in
            
        }
        return UISwipeActionsConfiguration(actions: [newAction])
    }
    
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader")
        //view?.backgroundColor = .systemRed
        //view?.contentView.backgroundColor = .systemRed
        let addButton = UIButton(type: .contactAdd)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        /*NSLayoutConstraint.activate([
            //tableView.topAnchor.constraint(equalTo: view.topAnchor),
            //tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view!.trailingAnchor)])
            //tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        //])*/
        
        view?.contentView.addSubview(addButton)
        return view
    }*/
}
