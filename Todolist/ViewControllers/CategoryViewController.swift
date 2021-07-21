//
//  CollectionViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 11/4/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var categoryItems: [CategoryItem] = []
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryItems = CategoryMenager.shered.categoryItems
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        refreshData()
    }
    func refreshData() {
        self.categoryItems = CategoryMenager.shered.categoryItems
        self.collectionView.reloadData()
    }
}
//MARK: CollectionView Delegates
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell  // as cell
        cell.setupUi(item: categoryItems[indexPath.row])
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTask" {
            if let viewController = segue.destination as? TaskViewController, let index = collectionView.indexPathsForSelectedItems?.first {
                viewController.category = categoryItems[index.item]
            }
        }
        refreshData()
    }
}
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width / 2
        return CGSize(width: width, height: width)
    }
}
