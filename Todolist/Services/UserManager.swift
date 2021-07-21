//
//  UserManager.swift
//  Todolist
//
//  Created by Petar Sakotic on 2/20/20.
//  Copyright © 2020 Petar Sakotic. All rights reserved.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    private init() {}
    private(set) var user: User? {
        didSet {
            UserDefaults.standard.set(self.user != nil, forKey: UserManager.isUserLoginUserDefaultKey)
            UserDefaults.standard.set(self.user?.id, forKey: UserManager.lastLogInUserIdDefaultKey)
        }
    }
    fileprivate static let lastLogInUserIdDefaultKey = "lastLogInUserIdDefaultKey"
    fileprivate static let isUserLoginUserDefaultKey = "isUserLoginUserDefaultKey"
    static let toDoItemsChangedNotificationName = "toDoItemChanged"
    var isLogin: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserManager.isUserLoginUserDefaultKey)
        }
    }
    func getLastSignInUser() -> User? {
        if isLogin, let id = UserDefaults.standard.string(forKey: UserManager.lastLogInUserIdDefaultKey) {
            initUser(id: id)
        }
        return user
    }
    func initUser(id: String, username: String? = nil) {
        let userData: UserData
        if let userDataDBValue = CoreDataManager.shared.getUser(id: id) {
            userData = userDataDBValue
        }
        else {
            let createNewUserInDB = CoreDataManager.shared.saveUser(id: id, username: username ?? "Unknown")
            userData = createNewUserInDB
        }
        updateUserReferenceFromDB(user: userData)
    }
    func updateUser(name: String){
        guard validateUsername(name: name) else { return }
        if let userToUpdate = CoreDataManager.shared.getUser(id: user!.id) {
            userToUpdate.username = name
            
            if CoreDataManager.shared.saveContext() {
                self.user?.name = name
            }
        }
        else {
            fatalError("Failed to get user")
        }
    }
    func removeCurrentUser() {
        self.user = nil
    }
    func removeUserFromDB(){
        if let id = self.user?.id {
            CoreDataManager.shared.deleteUser(id: id)
        }
    }
    func saveToDoItem(item: ToDoItem) {
        guard let userDB = getUserFromDB() else {
            fatalError("Failed to get user")
        }
        guard validateToDoItem(item: item) else {
            return
        }
        if let itemDB = CoreDataManager.shared.getTodoItem(id: item.id) {
            itemDB.name = item.name
            itemDB.checked = item.checked
            itemDB.date = item.date
            if item.category != nil {
                itemDB.category?.name = item.category!.name
                itemDB.category?.color = item.category!.color
            }
        } else {
            let itemDB = CoreDataManager.shared.createItem(item: item)
            userDB.addToToDoItems(itemDB)
        }
        CoreDataManager.shared.saveContext()
        updateUserReferenceFromDB(user: userDB)
    }
    func deleteToDoItem(item: ToDoItem) {
        guard let userDB = getUserFromDB() else {
            fatalError()
        }
        if let itemDB = CoreDataManager.shared.getTodoItem(id: item.id) {
            userDB.removeFromToDoItems(itemDB)
        } else {
            let itemDB = CoreDataManager.shared.createItem(item: item)
            userDB.addToToDoItems(itemDB)
        }
        CoreDataManager.shared.saveContext()
        updateUserReferenceFromDB(user: userDB)
    }
    //MARK: Private
    private func validateUsername(name: String) -> Bool {
        if name.isEmpty {
            return false
        } else if name.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        } else if name.rangeOfCharacter(from: CharacterSet.alphanumerics) == nil {
            return false
        }
        return true
    }
    private func validateToDoItem(item: ToDoItem) -> Bool {
        guard let name = item.name else {
            return false
        }
        if name.isEmpty {
            return false
        } else if item.date == nil {
            return false
        } else if item.category == nil {
            return false
        }
        return true
    }
    private func updateUserReferenceFromDB(user: UserData) {
        let convertedItems = convertDBToDoItems(toDoItems: user.toDoItems?.allObjects as! [ToDoItemData])
        let user = User(id: user.id!, name: user.username!, items: convertedItems)
        self.user = user
    }
    private func getUserFromDB() -> UserData? {
        guard let userID = self.user?.id else {
            return nil
        }
        return CoreDataManager.shared.getUser(id: userID)
    }
    private func convertDBToDoItems(toDoItems: [ToDoItemData]) -> [ToDoItem] {
        return toDoItems.map{ ToDoItem.convert(dbItem: $0) }
    }
}
