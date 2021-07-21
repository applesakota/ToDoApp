//
//  TabBarViewController.swift
//  Todolist
//
//  Created by Petar Sakotic on 10/23/19.
//  Copyright © 2019 Petar Sakotic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var secondText: UITextView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var imageBar: UIBarButtonItem!
    @IBOutlet weak var headerLabel: UILabel!
    lazy var tasks: [ToDoItem] = {
        return UserManager.shared.user?.items ?? []
    }()
    //MARK: View Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        observeChangesOnToDoItems()
        self.taskTableView.setSelectedRows(items: tasks)
    }
    //MARK: Observed
    func observeChangesOnToDoItems() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(ToDoItemMenager.toDoItemsChangedNotificationName), object: nil)
    }
    @objc func refreshData () {
        self.tasks = UserManager.shared.user?.items ?? []
        configureUI()
        self.taskTableView.reloadData()
        self.taskTableView.setSelectedRows(items: tasks)
    }
    //MARK: UI
    private func configureUI(){
        setHomeScreenWithoutTasks(image: UIImage(named: "tab bar"), name: "No tasks", description: "You have no task to do.")
        setNavigationBar(username: UserManager.shared.user?.name ?? "unknown")
        setHeader(tasksCount: tasks.count, completedTasks: 0)
        presentEmptyView(isEmpty: tasks.isEmpty)
    }
    private func configureTableView(){
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self
    }
     func setHeader(tasksCount: Int, completedTasks: Int) {
        var completedTasks = 0
        for task in tasks {
            if task.checked == true {
                completedTasks = completedTasks + 1
                headerLabel.text = "You have \(tasksCount) tasks, You completed \(completedTasks) tasks"
            }
        }
        headerLabel.text = "You have \(tasksCount) tasks, You completed \(completedTasks) tasks"
    }
    func setHomeScreenWithoutTasks(image: UIImage?, name: String, description: String) {
        imageView.image = image
        firstLabel.text = name
        secondText.text = description
    }
    func presentEmptyView (isEmpty: Bool) {
        if isEmpty {
            taskTableView.isHidden = true
            emptyView.isHidden = false
        } else {
            taskTableView.isHidden = false
            emptyView.isHidden = true
        }
    }
    func setNavigationBar(username: String) {
        let cutter = "@"
        if let result = username.components(separatedBy: cutter).first {
            navItem.title = "Hello \(result)"
        } else {
            navItem.title = "Hello"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditScreen" {
            if let addNewItemViewController = segue.destination as? AddNewItemViewController {
                if let cell = sender as? UITableViewCell, let indexPath = taskTableView.indexPath(for: cell) {
                    let item = tasks[indexPath.row]
                    addNewItemViewController.itemToEdit = item
                }
            }
        }
    }
    private func presentError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: Button actions
    @IBAction func signOutButton(_ sender: Any) {
        presentActionSheet()
    }
    func presentActionSheet(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Please select", message: "Do you want to logout", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "No", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        let logOutActionButton = UIAlertAction(title: "Yes", style: .default)
            { _ in
                self.signOutUser()
        }
        actionSheetController.addAction(logOutActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func signOutUser() {
        if let error = AuthenticateMenager.shared.singOut() {
            presentError(message: error.localizedDescription)
            return
        }
        GoogleAnalyticsManager.shared.customEvent(eventName: .userLogOut, eventParams: [:])
        UserManager.shared.removeCurrentUser()
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemCell
        let item = tasks[indexPath.row]
        cell.setUpUi(item: item)
        cell.markSelectedCell(item.checked)
        return cell
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
        taskTableView.reloadData()
    }
}



