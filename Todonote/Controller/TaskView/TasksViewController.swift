//
//  TasksViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 11.04.2022.
//

import UIKit
import RealmSwift

class TasksViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    //MARK: - vars/lets
    var categoryLabel: String?
    private let realm = try! Realm()
    var tasks: Results<Item>?
    var selectedCategory: Category?

    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController else { return }
        controller.selectedCategory = selectedCategory
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - flow func
    private func updateUI() {
        topView.layer.cornerRadius = 20
        categoryTitle.text = categoryLabel
    }
    
    private func loadTasks() {
//        tasks = realm.objects(Item.self)
        tasks = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        self.tableView.reloadData()
    }
    
    private func deleteTask(task: Item) {
        do {
            try realm.write({
                realm.delete(task)
            })
        } catch {
            debugPrint(error)
        }
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableViewCell", for: indexPath) as? TasksTableViewCell else { return UITableViewCell() }
        cell.configure(task: tasks![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as? TaskDetailViewController else { return }
        controller.item = tasks![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let task = tasks else { return }
    
        if editingStyle == .delete {
            self.deleteTask(task: task[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
