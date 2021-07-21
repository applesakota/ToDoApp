//
//  ThemeMenager.swift
//  Todolist
//
//  Created by Petar Sakotic on 11/18/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

protocol Theme {
    var taskNameColor: UIColor { get }
    var tastTimeLabel: UIColor { get }
}
class DarkMode: Theme {
    let taskNameColor: UIColor = .black
    let tastTimeLabel: UIColor = .black
}
class LightMode: Theme {
    let taskNameColor: UIColor = .black
    let tastTimeLabel: UIColor = .black
}
class CurrentTheme {
     static var current: Theme = DarkMode()
}


