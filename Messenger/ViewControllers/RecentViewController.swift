//
//  RecentViewController.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/10.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit
import CoreData

class RecentViewController: UIViewController {
   
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(RecentCell.self, forCellReuseIdentifier: RecentCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Friend> = {
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print(error)
        }
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recent"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(addButtonDidTap))
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        layoutTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    private func layoutTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addButtonDidTap() {
        let mark = Friend.instance(name: "Mark Zuckerberg", profileImageName: "zuckprofile")
        mark.say(text: "Hello, my name is Mark Zuckerberg", minutesAgo: 0)
        mark.say(text: "Nice to meet you", minutesAgo: 0)
    }
    
}

extension RecentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentCell.identifier) as! RecentCell
        let friend = fetchedResultsController.object(at: indexPath)
        
        cell.lastMessage = friend.lastMessage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let friend = fetchedResultsController.object(at: indexPath)
            Friend.delete(friend: friend)
        }
    }
}

extension RecentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ChatViewController()
        viewController.friend = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension RecentViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let atIndexPath = newIndexPath {
                tableView.insertRows(at: [atIndexPath], with: .fade)
            }
            
        case .delete:
            if let atIndexPath = indexPath {
                tableView.deleteRows(at: [atIndexPath], with: .fade)
            }
            
        case .update:
            if let atIndexPath = indexPath {
                tableView.reloadRows(at: [atIndexPath], with: .fade)
            }
            
        case .move:
            tableView.reloadData()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
