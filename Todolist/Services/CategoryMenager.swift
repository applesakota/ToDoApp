//
//  CategoryMenager.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/31/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation

enum CategoryManagerError: Error {
    case failedToLoadCategory
}
extension CategoryManagerError: LocalizedError {
    
}


class CategoryMenager {
    static let shered = CategoryMenager()
    var categoryItems : [CategoryItem] = []
    func getCategories () {
        readFromFile()
    }
    func readFromFile(){
        guard let path = Bundle.main.path(forResource: "Categories", ofType: "json") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let categories = json["categories"] {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: categories, options: .init()) {
                        let allCategoryItems = try JSONDecoder().decode([CategoryItem].self, from: jsonData)
                        categoryItems = allCategoryItems
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }

    
}


