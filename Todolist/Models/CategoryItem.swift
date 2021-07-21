//
//  CategoryItem.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/28/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

struct CategoryItem: Decodable, Equatable, Encodable {
    var id: Int
    var name: String? 
    var color: String?
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name
    }
}
extension CategoryItem {
    //MARK: UIColorFromString
    func getUiColor(alpha: CGFloat) -> UIColor {
       return UIColor.init(hexString: color ?? "",alpha: alpha)
    }
    func getImage() -> UIImage? {
        return UIImage(named: name ?? "")
    }
}
extension CategoryItem {
    static func convert(dbCategory: CategoryItemData) -> CategoryItem {
        let category = CategoryItem(id: Int(dbCategory.id), name: dbCategory.name, color: dbCategory.color)
        return category
    }
}


