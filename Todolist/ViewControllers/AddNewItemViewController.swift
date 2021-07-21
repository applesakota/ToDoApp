//
//  AddNewItemViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/29/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var selectedCategory: CategoryItem?
    var categoryItems: [CategoryItem] = []
    var itemToEdit: ToDoItem?
    var selectedCategoryPath: IndexPath?
    var newToDoItem: ToDoItem?
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryItems = CategoryMenager.shered.categoryItems
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        configureUI()
        self.taskNameTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if itemToEdit != nil {
            configureUIForEditView()
        }
    }
    private func createItem(){
        let newItem = ToDoItemMenager.shared.createNewItem(name: taskNameTextField.text, category: selectedCategory, date: datePicker.date)
        ToDoItemMenager.shared.createNewItem(newToDoItem: newItem, successHandler: {
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: {error in
            presentError(message: error.localizedDescription)
        })
    }
    private func editItem() {
        let editItem = ToDoItemMenager.shared.editItem(id: itemToEdit!.id, name: taskNameTextField.text, category: selectedCategory, date: datePicker.date)
        ToDoItemMenager.shared.editItem(itemToEdit: editItem, successHandler: {
            self.dismiss(animated: true, completion: nil)
        }, errorHandler: {error in
            presentError(message: error.localizedDescription)
        })
    }
    //MARK: Configure UI
    private func configureUI() {
        view.layer.cornerRadius = 30
        addTaskButton.layer.cornerRadius = 10.0
        datePicker.minimumDate = Date()
        let title = itemToEdit != nil ? "Edit Task" : "Add Task"
        addTaskButton.setTitle(title, for: .normal)
        GoogleAnalyticsManager.shared.customEvent(eventName: .userClickOnAddTask, eventParams: [:])
    }
    private func configureUIForEditView(){
        taskNameTextField.text = itemToEdit?.name
        if let itemDate = itemToEdit?.date {
            datePicker.date = itemDate
        }
        setSelectedCategory()
        selectedCategory = itemToEdit?.category
        GoogleAnalyticsManager.shared.customEvent(eventName: .userClickOnEditTask, eventParams: [:])
    }
    //MARK: Alert
    private func presentError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: Button Actions
    @IBAction func addTaskAction(_ sender: Any) {
        if itemToEdit != nil {
            editItem()
        } else {
            createItem()
        }
    }
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddNewItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categorySelected", for: indexPath) as! CategoryItemCell
        cell.setupScrollUI(item: categoryItems[indexPath.item])
        if indexPath == selectedCategoryPath {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            cell.setupSelectedBackground(isSelected: true)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categoryItems[indexPath.item]
        selectedCategoryPath = indexPath
    }
    func setSelectedCategory() {
        for (index, item) in categoryItems.enumerated() {
            if item == itemToEdit?.category {
                selectedCategoryPath = IndexPath(item: index, section: 0)
            }
        }
    }
}
extension AddNewItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
