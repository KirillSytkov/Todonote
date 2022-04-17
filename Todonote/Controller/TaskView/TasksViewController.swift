//
//  TasksViewController.swift
//  Todonote
//
//  Created by Kirill Sytkov on 11.04.2022.
//

import UIKit

class TasksViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    //MARK: - vars/lets
    var categoryLabel: String?
    var viewModel = TasksViewModel()

    //MARK: - lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getTask()
        updateUI()
    }
    
    //MARK: - IBActions
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: Constants.addTaskViewController) as? AddTaskViewController else { return }
        
        controller.viewModel.selectedCategory = viewModel.selectedCategory
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - flow func
    private func updateUI() {
        bottomView.layer.cornerRadius = 20
        tableView.layer.cornerRadius = 20
        categoryTitle.text = categoryLabel
    }
    
    private func bind() {
        viewModel.reloadTableView = {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cells.tasksTableViewCell, for: indexPath) as? TasksTableViewCell else { return UITableViewCell() }
        
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        
        cell.configure(task: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let controller = storyboard?.instantiateViewController(withIdentifier: Constants.taskDetailViewController) as? TaskDetailViewController else { return }
        
        controller.viewModel.task = viewModel.tasks![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            self.viewModel.deleteTask(indexPath: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
