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
    
    typealias SectionType = String
    typealias ItemType = SongModel
    
    var tableView: UITableView!
    var dataSource: DataSource!
    
    var repStore: RepStore!
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureNavigationItem()
        
        repStore = MockRepStore()
        configureDataSource()
        
        cancellable = repStore.foldersPublisher.sink(receiveValue: { [weak self] folderModels in
            var newSnapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
            
            for folder in folderModels {
                newSnapshot.appendSections([folder.name])
                newSnapshot.appendItems(folder.songs)
            }
            self?.dataSource.apply(newSnapshot)
        })
    }
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
        dataSource = DataSource(repStore: repStore, tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, songModel) -> UITableViewCell? in
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
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSong))
        navigationItem.rightBarButtonItem = addItem
        let editLabel = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.leftBarButtonItem = editLabel
    }
    
    @objc func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    @objc func addSong() {
        let ac = UIAlertController(title: "Add Song", message: "Title and Composer:", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] alertAction in
            guard let self = self else { return }
            let songTitle = ac?.textFields![0].text ?? ""
            let songComposer = ac?.textFields![1].text ?? ""
            self.repStore.addSongRandomly(song: SongModel(title: songTitle, composer: songComposer))
        }
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
}

extension HomeViewController {
    class DataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
        var repStore: RepStore
        
        init(repStore: RepStore, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<HomeViewController.SectionType, HomeViewController.ItemType>.CellProvider) {
            self.repStore = repStore
            super.init(tableView: tableView, cellProvider: cellProvider)
        }
        
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
                    /*var snapshot = self.snapshot()
                    snapshot.deleteItems([identifierToDelete])
                    apply(snapshot)*/
                    guard let songToRemove = itemIdentifier(for: indexPath) else { return }
                    repStore.deleteSong(song: songToRemove, from: nil)
                }
            }
        }
    }
}

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
