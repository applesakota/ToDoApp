//
//  FoundationExtensions.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/30/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

//MARK: Date
extension Date {
    func convertToString () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy"
        return dateFormatter.string(from: self)
        
    }
    func convertToTimeString () -> String {
        let dateFormatterToTime = DateFormatter()
        dateFormatterToTime.dateFormat = "HH:mm"
        return dateFormatterToTime.string(from: self)
    }
}

