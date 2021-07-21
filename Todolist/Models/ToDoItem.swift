//
//  ToDoList.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/24/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

protocol Checked {
    var checked: Bool { get set }
}
struct ToDoItem: Codable, Checked {
    var id: Int
    var name: String?
    var checked: Bool
    var date: Date?
    var category: CategoryItem?
}
extension ToDoItem {
    static func convert(dbItem: ToDoItemData) -> ToDoItem {
        var category : CategoryItem?
        if let categoryDB = dbItem.category {
            category = CategoryItem.convert(dbCategory: categoryDB)
        }
        let item = ToDoItem(id: Int(dbItem.id),
                            name: dbItem.name,
                            checked: dbItem.checked,
                            date: dbItem.date,
                            category: category)
        return item
    }
}
