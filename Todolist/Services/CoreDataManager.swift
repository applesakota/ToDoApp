//
//  CoreDataManager.swift
//  Todolist
//
//  Created by Petar Sakotic on 1/8/20.
//  Copyright © 2020 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getUser(id: String) -> UserData? {
        let item: UserData? = getFirstItem(id: id)
        return item
    }
    func getTodoItem(id: Int) -> ToDoItemData? {
        return getFirstItem(id: "\(id)")
    }
    func getCategory(id: String) -> CategoryItemData? {
        return getFirstItem(id: id)
    }
    func saveUser(id: String, username: String) -> UserData {
        
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context) as! UserData
        newUser.id = id
        newUser.username = username
        if saveContext() {
            return newUser
        } else {
            fatalError("failed to create new user")
        }
    }
    func createCategoryItem(item: CategoryItem) -> CategoryItemData {
        let entity = NSEntityDescription.entity(forEntityName: "CategoryItemData", in: context)
        let newCategory = NSManagedObject(entity: entity!, insertInto: context) as! CategoryItemData
        newCategory.setValue(item.name, forKey: "name")
        newCategory.setValue(item.color, forKey: "color")
        if saveContext() {
            return newCategory
        } else {
            fatalError("failed to create new Category")
        }
    }
    
    func createItem(item: ToDoItem) -> ToDoItemData {
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDoItemData", in: context)
        let newItem = NSManagedObject(entity: entity!, insertInto: context) as! ToDoItemData
        newItem.setValue(item.id, forKey: "id")
        newItem.setValue(item.name, forKey: "name")
        newItem.setValue(item.checked, forKey: "checked")
        newItem.setValue(item.date, forKey: "date")
        if getCategory(id: String(item.id)) != nil {
            newItem.setValue(item.category, forKey: "category")
        } else {
            newItem.setValue(createCategoryItem(item: item.category!), forKey: "category")
        }
        if saveContext() {
            return newItem
        } else {
            fatalError("failed to create new item")
        }
    }
    func deleteUser(id: String) -> Bool {
        do {
            if let user = getUser(id: id) {
                context.delete(user)
            }
        }
        catch {
            print("Can't get user")
        }
        return saveContext()
    }
    func deleteItem(id: Int) -> Bool {
        do {
            if let item = getTodoItem(id: id) {
                context.delete(item)
            }
        } catch {
            print("Error get item")
        }
        return saveContext()
    }
    @discardableResult func saveContext() -> Bool {
        do {
            try context.save()
        } catch {
            return false
        }
        return true
    }
    //MARK: Private
    private func getFirstItem<T: NSManagedObject> (id: String) -> T? {
        let request: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
        request.predicate = NSPredicate.init(format: "id == %@", id)
        do {
            let result = try context.fetch(request)
            return result.first
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
