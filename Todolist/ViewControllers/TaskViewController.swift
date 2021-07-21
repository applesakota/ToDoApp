//
//  TaskViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 11/6/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskOfCategoryTableView: UITableView!
    
    var category: CategoryItem!
    private var tasks: [ToDoItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshTasksData()
        observerListenChangesOnTasksData()
    }
    func observerListenChangesOnTasksData() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTasksData), name: NSNotification.Name(ToDoItemMenager.toDoItemsChangedNotificationName), object: nil)
    }
    @objc func refreshTasksData() {
        self.tasks = UserManager.shared.user?.items ?? []
        taskOfCategoryTableView.setSelectedRows(items: tasks)
        self.taskOfCategoryTableView.reloadData()
        configureUI()
        configureTableData()
    }
    //MARK: ConfigureUI
    func configureUI() {
        view.layer.cornerRadius = 30
    }
    func configureTableData(){
        let allTasks = UserManager.shared.user?.items ?? []
        self.taskOfCategoryTableView.dataSource = self
        self.taskOfCategoryTableView.delegate = self
        self.taskOfCategoryTableView.allowsMultipleSelection = true
        self.taskOfCategoryTableView.allowsMultipleSelectionDuringEditing = true
        self.tasks = allTasks.filter { (item) -> Bool in
        return item.category == category
        }
        taskOfCategoryTableView.reloadData()
        taskOfCategoryTableView.setSelectedRows(items: tasks)
    }
}
//MARK: TableView Data
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as? ToDoItemCell
        cell?.setUpUi(item: tasks[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = tasks[indexPath.row]
        ToDoItemMenager.shared.toggleChecked(id: item.id)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = tasks[indexPath.row]
        ToDoItemMenager.shared.toggleChecked(id: item.id)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = tasks[indexPath.row]
            ToDoItemMenager.shared.deleteItem(id: item.id)
        }
    }
}
