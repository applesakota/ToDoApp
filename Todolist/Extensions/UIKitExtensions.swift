//
//  UIKitExtensions.swift
//  Todolist
//
//  Created by Petar Sakotic on 12/16/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

//MARK: Color
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
//MARK: TableView
extension UITableView {
    func setSelectedRows<T: Checked>(items: [T]) {
        var selectedIndecies: [IndexPath] = []
        for (index, item) in items.enumerated() {
            if item.checked == true {
                selectedIndecies.append(IndexPath(row: index, section: 0))
            }
        }
        for index in selectedIndecies {
            self.selectRow(at: index, animated: false, scrollPosition: .none)
        }
    }
}

