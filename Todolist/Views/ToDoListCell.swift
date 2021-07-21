//
//  ToDoListCell.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/23/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

class ToDoItemCell: UITableViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var tastTimeLabel: UILabel!
    @IBOutlet weak var doneIndicatorImageView: UIImageView!
    @IBOutlet weak var categoryColorView: UIView!
    @IBOutlet weak var parentView: UIView!
    
    func setUpUi(item: ToDoItem) {
        taskNameLabel.text = item.name
        taskNameLabel.textColor = CurrentTheme.current.taskNameColor
        tastTimeLabel.textColor = CurrentTheme.current.tastTimeLabel
        tastTimeLabel.text = item.date?.convertToTimeString()
        doneIndicatorImageView.image = item.checked ? UIImage(named: "checked") : UIImage(named: "unchecked")
        categoryColorView.backgroundColor = item.category?.getUiColor(alpha: 1)
        parentView.layer.cornerRadius = 10
    }
    func markSelectedCell(_ selected: Bool){
        if selected {
            doneIndicatorImageView.image = UIImage(named: "checked")
        } else {
            doneIndicatorImageView.image = UIImage(named: "unchecked")
        }
    }
}

