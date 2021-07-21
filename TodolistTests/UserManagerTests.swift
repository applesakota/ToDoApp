//
//  TodolistTests.swift
//  TodolistTests
//
//  Created by Dusan Cucurevic on 24/02/2020.
//  Copyright © 2020 Petar Sakotic. All rights reserved.
//

import XCTest
@testable import Todolist

class UserManagerTests: XCTestCase {
    
    var userData: UserData?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserManager.shared.initUser(id: "1")
    }
    
    override func tearDown() {
        CoreDataManager.shared.deleteUser(id: "1")
        CoreDataManager.shared.deleteItem(id: 123)
    }
    
    //MARK:- User
    func testInitUser() {
        XCTAssertNotNil(UserManager.shared.user)
    }
    
    func testUpdateUserName() {
        UserManager.shared.updateUser(name: "Test")
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        XCTAssertEqual(user?.username, "Test")
    }
    
    func testUpdateUserNameWithEmptyString() {
        let previousUsername = UserManager.shared.user?.name
        UserManager.shared.updateUser(name: "")
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        XCTAssertEqual(user?.username, previousUsername)
    }
    
    func testUpdateUserNameWithNonString() {
        let previousUsername = UserManager.shared.user?.name
        let elements = "! @ # & ( ) – [ { } ] : ; ' , ? / * ` ~ $ ^ + = < > “"
        let char = String(elements.split(separator: " ").randomElement()!)
        UserManager.shared.updateUser(name: char)
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        XCTAssertEqual(previousUsername, user?.username)
    }
    
    func testUpdateUsernameWithAlphanumericAndOneSpecialCharacter() {
        let name = "Pera!"
        UserManager.shared.updateUser(name: name)
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        XCTAssertEqual(user?.username, name)
    }
    
    func testRemoveCurrentUserManagerUser() {
        UserManager.shared.removeCurrentUser()
        XCTAssertNil(UserManager.shared.user)
    }
    
    //MARK:- To do items
    func testCreateNewToDoItem() {
        insertItem()
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItemName = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })?.name
        
        XCTAssertEqual("test", userToDoItemName)
    }
    
    func testCreateNewToDoItemWithNilName() {
        let newItem = ToDoItem(id: 123, name: nil, checked: false, date: Date(), category: nil)
        UserManager.shared.saveToDoItem(item: newItem)
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItem = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })
        XCTAssertNil(userToDoItem)
    }
    
    func testCreateNewToDoItemWithNilDate() {
        let newItem = ToDoItem(id: 123, name: "test", checked: false, date: nil, category: nil)
        UserManager.shared.saveToDoItem(item: newItem)
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItem = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })
        XCTAssertNil(userToDoItem)
    }
    
    func testEditNewToDoItemName() {
        var newItem = insertItem()
        newItem.name = "new_test_name"
        UserManager.shared.saveToDoItem(item: newItem)
        
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItemName = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })?.name
        XCTAssertEqual("new_test_name", userToDoItemName)
    }
    
    func testEditNewToDoItemChecked() {
        var newItem = insertItem()
        newItem.checked = true
        UserManager.shared.saveToDoItem(item: newItem)
        
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItemChecked = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })?.checked
        XCTAssertEqual(true, userToDoItemChecked)
    }
    
    func testEditNewToDoItemDate() {
        var newItem = insertItem()
        let newDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        newItem.date = newDate
        UserManager.shared.saveToDoItem(item: newItem)
        
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItemDate = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })?.date
        XCTAssertEqual(newDate, userToDoItemDate)
    }
    
    func testDeleteToDoItem() {
        insertItem()
        deleteItem()
        refreshUser()
        let userToDoItemDeleted = (userData?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })
        XCTAssertNil(userToDoItemDeleted)
    }
    
    //MARK:- Update user reference
    func testUserReferenceUsername() {
        UserManager.shared.updateUser(name: "Test")
        XCTAssertEqual(UserManager.shared.user?.name, "Test")
    }
    
    func testUserReferenceCreateNewItem() {
        insertItem()
        refreshUser()
        XCTAssertEqual(UserManager.shared.user?.items.count, userData?.toDoItems?.count)
    }
    
    func testUserReferenceEditItem() {
        var newItem = insertItem()
        newItem.name = "new_test_name"
        UserManager.shared.saveToDoItem(item: newItem)
        refreshUser()
        XCTAssertEqual(UserManager.shared.user?.items.count, userData?.toDoItems?.count)
    }
    
    func testUserReferenceDeleteItem() {
        insertItem()
        deleteItem()
        refreshUser()
        XCTAssertEqual(UserManager.shared.user?.items.count, userData?.toDoItems?.count)
    }
    func testCreateNewItemWithCategory() {
        let newItem = ToDoItem(id: 123, name: "test", checked: false, date: Date(), category: CategoryItem(name: "Test", color: "#000000"))
        UserManager.shared.saveToDoItem(item: newItem)
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItemCategory = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })?.category
        XCTAssertNotNil(userToDoItemCategory)
    }
    func testChangeItemCategory() {
        insertItem()
        let editedItem = ToDoItem(id: 123, name: "test", checked: false, date: Date(), category: CategoryItem(name: "Edited title", color: "#ffffff"))
        UserManager.shared.saveToDoItem(item: editedItem)
        let user = CoreDataManager.shared.getUser(id: UserManager.shared.user!.id)
        let userToDoItemCategory = (user?.toDoItems as? Set<ToDoItemData>)?.first(where: { $0.id == 123 })?.category
        XCTAssertEqual(userToDoItemCategory?.name, editedItem.category?.name)
    }
    @discardableResult private func insertItem() -> ToDoItem {
        let newItem = ToDoItem(id: 123, name: "test", checked: false, date: Date(), category: CategoryItem(name: "Test", color: "#000000"))
        UserManager.shared.saveToDoItem(item: newItem)
        return newItem
    }
    private func deleteItem() {
        let newItemToDelete = ToDoItem(id: 123, name: nil, checked: false, date: nil, category: nil)
        UserManager.shared.deleteToDoItem(item: newItemToDelete)
    }
    private func refreshUser() {
        userData = CoreDataManager.shared.getUser(id: "1")
    }
}
