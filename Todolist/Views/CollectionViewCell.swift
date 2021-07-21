//
//  CollectionViewCell.swift
//  Todolist
//
//  Created by Petar Sakotic on 12/6/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit
class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var collectionCountLabel: UILabel!
    var item: CategoryItem!
    
    func setupUi(item: CategoryItem) {
        self.item = item
        collectionNameLabel.text = item.name
        makeCircular()
        parentView.backgroundColor = item.getUiColor(alpha: 0.5)
        imageView.image = item.getImage()
        configureCollectionCountLabel()
    }
    func makeCircular() {
        self.layoutIfNeeded()
        parentView.layer.cornerRadius = parentView.frame.size.width / 2
    }
    func configureCollectionCountLabel (){
        let allTasks = UserManager.shared.user?.items ?? []
        let tasksCount = allTasks.filter { (itemTask) -> Bool in
            return itemTask.category == item
        }.count
        collectionCountLabel.text = "\(tasksCount) Tasks"
        collectionCountLabel.textColor = .black
    }
}
