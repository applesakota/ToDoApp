//
//  ToDoItemMenager.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/28/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
enum ToDoItemManegerError: Error {
    case failedToSave
    case nameAlreadyUsed
    case emptyTaskName
    case cantBeOnlyWhiteSpace
    case categoryItemNotSelected
}
extension ToDoItemManegerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nameAlreadyUsed:
            return NSLocalizedString("Name already used", comment: "")
        case .failedToSave:
            return NSLocalizedString("Failed to save", comment: "")
        case .emptyTaskName:
            return NSLocalizedString("Task name can not be empty", comment: "")
        case .cantBeOnlyWhiteSpace:
            return NSLocalizedString("You can not enter only white space", comment: "")
        case .categoryItemNotSelected:
            return NSLocalizedString("You must select one category", comment: "")
        }
    }
}
class ToDoItemMenager {
    
    
    
    static let shared = ToDoItemMenager()
    static let toDoItemsChangedNotificationName = "toDoItemChanged"
    private var todoItems: [ToDoItem] = []
    
    private init(){
        getAllItems()
    }
    
    
    public func createNewItem(newToDoItem: ToDoItem, successHandler: ()->Void , errorHandler: (_ error: Error) ->Void ) {
        if let error = validate(item: newToDoItem) {
            errorHandler(error)
            return
        }
        if saveItem(item: newToDoItem) {
            NotificationCenter.default.post(name: NSNotification.Name(ToDoItemMenager.toDoItemsChangedNotificationName), object: nil)
            successHandler()
        } else {
            errorHandler(ToDoItemManegerError.failedToSave)
        }
        getAllItems()
    }
    public func createNewItem(name: String?,category: CategoryItem?, date: Date) -> ToDoItem {
        return ToDoItem(id: getUniqueId(), name: name, checked: false, date: date, category: category)
    }
    public func editItem(id: Int,name: String?,category: CategoryItem?, date:Date) -> ToDoItem {
        getAllItems()
        var editItem = selectedItem(id: id)
        editItem.name = name
        editItem.category = category
        editItem.date = date
        return editItem
    }
    func getAllItems() {
        self.todoItems = UserManager.shared.user?.items ?? []
    }
    public func editItem(itemToEdit: ToDoItem, successHandler: ()->Void , errorHandler: (_ error: Error) ->Void) {
        if let error = validate(item: itemToEdit) {
            errorHandler(error)
            return
        }
        if saveItem(item: itemToEdit) {
            NotificationCenter.default.post(name: NSNotification.Name(ToDoItemMenager.toDoItemsChangedNotificationName), object: nil)
            GoogleAnalyticsManager.shared.customEvent(eventName: .userEditedTask, eventParams: [:])
            successHandler()
        } else {
            errorHandler(ToDoItemManegerError.failedToSave)
        }
    }
    public func deleteItem(id: Int) {
        UserManager.shared.deleteToDoItem(item: selectedItem(id: id))
        NotificationCenter.default.post(name: NSNotification.Name(ToDoItemMenager.toDoItemsChangedNotificationName), object: nil)
    }
    public func toggleChecked(id: Int) {
        if let itemIndex = todoItems.firstIndex(where: { (item) -> Bool in
            return item.id == id
        }){
            var newItem = todoItems[itemIndex]
            newItem.checked.toggle()
            todoItems[itemIndex] = newItem
            if saveItem(item: newItem) {
                NotificationCenter.default.post(name: NSNotification.Name(ToDoItemMenager.toDoItemsChangedNotificationName), object: nil)
                GoogleAnalyticsManager.shared.customEvent(eventName: .userEditedTask, eventParams: [:])
            } else {
                return
            }
        }
    }
    //MARK: Private
    private func getUniqueId() -> Int {
        var uniqueId = 0
        for item in todoItems {
            if item.id >= uniqueId {
                uniqueId = item.id + 1
            }
        }
        return uniqueId
    }
    private func selectedItem(id:Int) -> ToDoItem {
        let itemSelected = todoItems.filter { (item) -> Bool in
            return item.id == id
        }.first
        return itemSelected!
    }
    private func validate(item: ToDoItem) -> Error? {
        if item.name!.isEmpty {
            return ToDoItemManegerError.emptyTaskName
        } else if item.name!.trimmingCharacters(in: .whitespaces).isEmpty {
            return ToDoItemManegerError.cantBeOnlyWhiteSpace
        } else if item.category == nil {
            return ToDoItemManegerError.categoryItemNotSelected
        }
        return nil
    }
    private func saveItem(item: ToDoItem) -> Bool {
        UserManager.shared.saveToDoItem(item: item)
        return CoreDataManager.shared.saveContext()
    }
}

