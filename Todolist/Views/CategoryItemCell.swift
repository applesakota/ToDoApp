//
//  CategoryItemCell.swift
//  Todolist
//
//  Created by Petar Sakotic on 11/4/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import Foundation
import UIKit

class CategoryItemCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCollectionLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    var item: CategoryItem!
    override var isSelected: Bool {
        didSet {
            setSelectedCell(isSelected: isSelected)
        }
    }
    func setupUi(item: CategoryItem) {
        self.item = item
        categoryNameLabel.text = item.name
        makeCircular()
        parentView.backgroundColor = item.getUiColor(alpha: 0.5)
    }
    func makeCircular() {
        self.layoutIfNeeded()
        parentView.layer.cornerRadius = parentView.frame.size.width / 2
    }
    func setupScrollUI(item: CategoryItem) {
        self.item = item
        categoryCollectionLabel.text = item.name
        circleView.backgroundColor = item.getUiColor(alpha: 1)
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
    }
    func setupSelectedBackground(isSelected: Bool) {
        parentView.backgroundColor = isSelected ? item.getUiColor(alpha: 1) : UIColor.clear
        categoryCollectionLabel.textColor = isSelected ? UIColor.white : UIColor.lightGray
        makeBorderRadius()
    }
    func makeBorderRadius(){
        self.layoutIfNeeded()
        parentView.layer.cornerRadius = 10
    }
    func setSelectedCell(isSelected: Bool) {
        print("isSelected \(isSelected)")
        setupSelectedBackground(isSelected: isSelected)
    }
}
