//
//  CoreDataHelper.swift
//  Messenger
//
//  Created by didYouUpdateCode on 2017/4/25.
//  Copyright © 2017年 didYouUpdateCode. All rights reserved.
//

import UIKit
import CoreData

extension Friend {
    
    static func instance(name: String, profileImageName: String) -> Friend {
        guard let friend = fetch(name: name, profileImageName: profileImageName) else {
            let newFriend = create(name: name, profileImageName: profileImageName)
            return newFriend
        }
        
        return friend
    }
    
    private static func create(name: String, profileImageName: String) -> Friend {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let friend = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        friend.name = name
        friend.profileImageName = profileImageName
        
        delegate.saveContext()
        
        return friend
    }
    
    private static func fetch(name: String, profileImageName: String) -> Friend? {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@ && profileImageName = %@", name, profileImageName)
        
        var friend: Friend?
        
        do {
            friend = try context.fetch(fetchRequest).first
        } catch {
            print(error)
        }
        
        return friend
    }
    
    static func delete(friend: Friend) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        if let messages = friend.message?.allObjects as? [Message] {
            for message in messages {
                context.delete(message)
            }
            
            context.delete(friend)
        }
        
        delegate.saveContext()
    }
    
    func say(text: String, minutesAgo: Double) {
        let newMessage = createMessage(text: text, minutesAgo: minutesAgo, isSender: false)
        addToMessage(newMessage)
        lastMessage = newMessage
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func read(text: String, minutesAgo: Double) {
        let newMessage = createMessage(text: text, minutesAgo: minutesAgo, isSender: true)
        addToMessage(newMessage)
        lastMessage = newMessage
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    private func createMessage(text: String, minutesAgo: Double, isSender: Bool) -> Message {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender
        message.friend = self
        
        return message
    }
}


class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    
    private lazy var context = CoreDataHelper.shared.delegate.persistentContainer.viewContext
    
    func setupData() {
        let steve = Friend.instance(name: "Steve Jobs", profileImageName: "steve_profile")
        steve.say(text: "Good morning", minutesAgo: 2)
        steve.say(text: "Hello, how are you? Hope you have a good morning.", minutesAgo: 1)
        steve.say(text: "Apple creates great iOS devices for the world. Are you interesting in buying an Apple device? We have a wide variety Apple devices that will suit your needs. Please make your purchase with us.", minutesAgo: 0)
        steve.read(text: "Yes, totally looking to buy an iPhone 8", minutesAgo: 0)
        steve.say(text: "Totally understand that you want the new iPhone 8, but you'll have to wait until September for the new release. Sorry, but thats just how Apple likes to do things.", minutesAgo: 0)
        steve.read(text: "Absolutely, I'll just use my iPhone 6 until then!", minutesAgo: 0)
        
        let donald = Friend.instance(name: "Donald Trump", profileImageName: "donald_trump_profile")
        donald.say(text: "You're fired", minutesAgo: 60 * 24)
        
        let gandhi = Friend.instance(name: "Mahatma Gandhi", profileImageName: "gandhi")
        gandhi.say(text: "Love, Peace, and Joy", minutesAgo: 60 * 24 * 10)
        
        let hillary = Friend.instance(name: "Hillary Clinton", profileImageName: "hillary_profile")
        hillary.say(text: "Vote me, you did for billy!", minutesAgo: 60 * 24 * 400)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func clearData() {
        do {
            let entityNames = ["Message", "Friend"]
            
            for name in entityNames {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try delegate.persistentContainer.persistentStoreCoordinator.execute(batchRequest, with: context)
            }
            
        } catch {
            print(error)
        }
        
        delegate.saveContext()
    }
    
    private init() {}
}
