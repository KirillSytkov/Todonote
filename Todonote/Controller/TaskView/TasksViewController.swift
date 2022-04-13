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
    let realm = try! Realm()
    private var tasks: Results<Item>?
    
    //MARK: - lyfecycle
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController else { return }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: - flow func
    private func updateUI() {
        topView.layer.cornerRadius = 10
    }
    
    private func loadCategory() {
        tasks = realm.objects(Item.self)
        self.tableView.reloadData()
    }
    
    private func deleteCategory(task: Item) {
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
        
        return cell
    }
  
}
