//
//  ChatViewController.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/25.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    var friend: Friend? {
        willSet {
            title = newValue?.name
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend?.name ?? "")
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
    
    fileprivate var tableViewBottomConstraint: NSLayoutConstraint?
    
    fileprivate var inputViewContainerBottomConstraint: NSLayoutConstraint?
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    fileprivate lazy var inputViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type a message"
        return textField
    }()
    
    fileprivate lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(sendButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerKeyboardEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulateButtonDidTap))
        
        view.addSubview(tableView)
        view.addSubview(inputViewContainer)
        inputViewContainer.addSubview(inputTextField)
        inputViewContainer.addSubview(sendButton)
        
        layoutTableView()
        layoutInputViewContainer()
        layoutInputTextField()
        layoutSendButton()
    }
    
    private func layoutTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomConstraint?.isActive = true
    }
    
    private func layoutInputViewContainer() {
        inputViewContainer.translatesAutoresizingMaskIntoConstraints = false
        inputViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        inputViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        inputViewContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
        inputViewContainerBottomConstraint = inputViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        inputViewContainerBottomConstraint?.isActive = true
        
        let line = UIView()
        line.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        inputViewContainer.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.leadingAnchor.constraint(equalTo: inputViewContainer.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: inputViewContainer.trailingAnchor).isActive = true
        line.topAnchor.constraint(equalTo: inputViewContainer.topAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func layoutInputTextField() {
        let layoutGuide = inputViewContainer.layoutMarginsGuide
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        inputTextField.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
    }
    
    private func layoutSendButton() {
        let layoutGuide = inputViewContainer.layoutMarginsGuide
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.leadingAnchor.constraint(equalTo: inputTextField.trailingAnchor, constant: 8).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
    }
    
    private func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEventHandler), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardEventHandler), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardEventHandler(notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animationCurve = UIViewAnimationOptions(rawValue: (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).uintValue) 
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.tableViewBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            self.inputViewContainerBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        })
    }
    
    func scrollToBottom() {
        if let count = fetchedResultsController.fetchedObjects?.count {
            let indexPath = IndexPath(row: count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    func simulateButtonDidTap() {
        friend?.say(text: "Simulated message 1", minutesAgo: 0)
        friend?.say(text: "Simulated message 2", minutesAgo: 0)
    }
    
    func sendButtonDidTap() {
        guard let text = inputTextField.text, !text.isEmpty else {
            return
        }
        
        friend?.read(text: text, minutesAgo: 0)

        inputTextField.text = nil
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        
        cell.message = message
        
        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
}

extension ChatViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .none)
            }
        
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        scrollToBottom()
    }
    
}
